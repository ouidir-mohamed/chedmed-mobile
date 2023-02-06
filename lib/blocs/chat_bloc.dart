import 'dart:async';

import 'package:chedmed/models/conversation.dart';
import 'package:chedmed/models/conversation_request.dart';
import 'package:chedmed/models/conversation_user.dart';
import 'package:chedmed/models/message.dart';
import 'package:chedmed/models/message_request.dart';
import 'package:chedmed/models/typing_request.dart';
import 'package:chedmed/ressources/firebase/cloud_messaging.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/websocket/chat_socket.dart';
import 'package:chedmed/utils/time_formatter.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/message_type.dart';

class ChatBloc {
  BehaviorSubject<List<Conversation>> _conversationsSubject =
      BehaviorSubject<List<Conversation>>();

  BehaviorSubject<List<Message>> _singleConversationSubject =
      BehaviorSubject<List<Message>>();

  Stream<List<Conversation>> get getConvesations =>
      _conversationsSubject.stream;
  Stream<List<Message>> get getSingleConversation =>
      _singleConversationSubject.stream;

  PublishSubject<bool> _typingSubject = PublishSubject<bool>();
  Stream<bool> get getTyping => _typingSubject.stream;
  int? get getCurrentConversationId => _conversationId;
  int? _conversationId = null;
  int? _receipientId = null;

// public methodes
  init() {
    _conversationsSubject.sink.add([]);
    _singleConversationSubject.sink.add([]);

    CloudMessagingService.getMessages.listen((event) {
      _addNewMessage(event.conversation_id, event);
    });
  }

  loadAllConversations() async {
    await chedMedApi
        .getConversations(1)
        .then((value) => {_setConversations(value)})
        .catchError((Object obj) async {
      print("conx error  retry in 3 seconds .... 1");

      await Future.delayed(Duration(seconds: 3));
      loadAllConversations();
      return Future.value(Set());
    });
  }

  // called when a conversation screen is opend
  startConversation(int? conversationId, int receipientId) async {
    // if conversation is null means that conversation screen was opened from profile
    //  otherwise it was from conversation list
    this._receipientId = receipientId;

    if (conversationId != null) {
      this._conversationId = conversationId;
      _loadSingleConversation(conversationId);
      return;
    }

    print("no id :)");

    Conversation? conversation = null;
    //if conversatioId is null we call the server to recover the last existing onversation
    await chedMedApi.gatConversationWithUser(receipientId).then((value) {
      conversation = value;
      print("potential sucees");
    }).catchError((Object obj) async {
      if (obj.runtimeType == DioError) {
        DioError dioError = obj as DioError;
        if (dioError.response!.statusCode == 404) return;
      }
      print("conx error  retry in 3 seconds .... 2");
      await Future.delayed(Duration(seconds: 3));
      startConversation(conversationId, receipientId);

      return null;
    });
    // if everything is okay we load that conversation
    if (conversation != null) {
      this._conversationId = conversation!.id;

      _loadSingleConversation(this._conversationId!);
      return;
    }
  }

  leaveConversation() {
    print("left conversation");
    _singleConversationSubject.sink.add([]);
    _conversationId = null;
    _receipientId == null;
    int lastMessageId = 0;
    chatSocket.leaveConversation();
    _messagesSubscription!.pause();
    _typingSubscription!.pause();
  }

  requestOlderMessages(
    int conversationId,
  ) {
    print("older .....");
    List<Message> messages = _singleConversationSubject.hasValue
        ? _singleConversationSubject.value
        : [];

    int lastMessageId = messages.first.id;

    chedMedApi.getConversation(conversationId, lastMessageId).then((value) {
      List<Message> newMessages = messages;

      List<Message> oldMessages = value.messages.reversed.toList();
      newMessages.insertAll(0, oldMessages);
      _setConversationMessages(conversationId, newMessages);
    });
  }

  int tempIdCounter = 0;

  _sendMessage(int receipientId, String content, MessageType type,
      {bool isRetrying = false,
      int? conversationId,
      int? oldTempId,
      int? voiceDuration}) async {
    if (!isRetrying) {
      this._receipientId = receipientId;
    }
    // check if receipientId was changed than wait and retry later
    // if (this.receipientId != receipientId) {
    //   await Future.delayed(Duration(seconds: 3));
    //   sendMessage(receipientId, content,
    //       isRetrying: true, oldTempId: oldTempId);
    //   return;
    // }

// if theres no conversation started with receipient then create a new one
//////// has to be changed
    if (this._conversationId == null) {
      Conversation conv = await _createConversation(receipientId);
      _conversationId = conv.id;
      conversationId = conv.id;
      _addConversation(conv);
      _joinConversation(conv.id);
      print("---------------------");
    }

    List<Message> messages = isRetrying
        ? _getMessagesByConversaton(conversationId!)
        : _singleConversationSubject.hasValue
            ? _singleConversationSubject.value
            : [];

    if (!isRetrying) {
      conversationId = this._conversationId;
      tempIdCounter++;
      messages.add(Message(
          id: tempIdCounter,
          body: content,
          seen: false,
          createdAt: DateTime.now().toUtc().toUtcDateTimeString(),
          isSent: true,
          type: type,
          conversation_id: conversationId!,
          pending: true,
          voicePath: type == MessageType.VOCAL ? content : null,
          voiceDuration: type == MessageType.VOCAL ? voiceDuration : null));
      _setConversationMessages(conversationId, messages);
    }

    int tempId = oldTempId ?? tempIdCounter;

    chedMedApiFormData
        .sendMessage(MessageRequest(
            recipientId: receipientId,
            privateMessage: content,
            mediaPaths: type == MessageType.VOCAL ? [content] : [],
            voiceDuration: type == MessageType.VOCAL ? voiceDuration : null,
            type: type))
        .then((value) {
      //TODO

      List<Message> messages = _getMessagesByConversaton(conversationId!);

      print("success");
      // this has to be changed !!!!

      //////////////////////////////
      ///
      ///
      var pendingTopUpdateIndex = messages.indexWhere((element) {
        return element.id == tempId && element.pending == true;
      });
      messages[pendingTopUpdateIndex].pending = false;
      _setConversationMessages(conversationId, messages);
    }).catchError((Object obj) async {
      if (obj.runtimeType == DioError) {
        print((obj as DioError).message);
        print("conx error  retry in 3 seconds .... 3");

        await Future.delayed(Duration(seconds: 3));
        _sendMessage(receipientId, content, type,
            isRetrying: true,
            conversationId: conversationId,
            oldTempId: tempId,
            voiceDuration: voiceDuration);
      } else {
        print(obj);
      }

      return null;
    });
  }

  sendVocalMessage(int receipientId, String filePath, int voiceDuration) =>
      _sendMessage(receipientId, filePath, MessageType.VOCAL,
          voiceDuration: voiceDuration);

  sendTextMessage(int receipientId, String content) =>
      _sendMessage(receipientId, content, MessageType.TEXT);

  startTyping(int receipientId) {
    chedMedApi
        .imTyping(TypingRequest(recipientId: receipientId))
        .catchError((Object error) {});
  }

//private metheodes
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;

  _loadSingleConversation(int conversationId) {
    if (this._conversationId != conversationId) return;
    int lastMessageId = 0;

    try {
      _setConversationMessages(
        conversationId,
        _conversationsSubject.value
            .firstWhere((element) => element.id == conversationId)
            .messages,
      );
    } catch (e) {}
    chedMedApi.getConversation(conversationId, lastMessageId).then((value) {
      print(value.messages.length.toString() + " messages");
      _setConversationMessages(conversationId, value.messages);
    }).catchError((Object obj) async {
      print(obj);
      if (this._conversationId != conversationId) return null;
      print(
          "conx error  retry in 3 seconds .... 4 " + conversationId.toString());
      await Future.delayed(Duration(seconds: 3));
      _loadSingleConversation(conversationId);

      return null;
    });

    _joinConversation(conversationId);
  }

  _joinConversation(int conversationId) {
    if (this._conversationId != conversationId) return;
    chatSocket.joinConvcersation(conversationId);
    if (_messagesSubscription == null) {
      _messagesSubscription = chatSocket.getMessages.listen((event) {
        _typingSubject.sink.add(false);

        _addNewMessage(conversationId, event);
      });

      _typingSubscription = chatSocket.getTyping.listen((event) {
        _typingSubject.sink.add(true);
      });
    } else {
      _messagesSubscription!.resume();
      _typingSubscription!.resume();
    }
  }

  List<Message> _getMessagesByConversaton(int conversationId) {
    if (conversationId == this._conversationId) {
      return _singleConversationSubject.hasValue
          ? _singleConversationSubject.value
          : [];
    }
    var conversations = _conversationsSubject.value;

    if (conversations.isEmpty) return [];
    return _conversationsSubject.value
        .firstWhere((element) => element.id == conversationId)
        .messages;
  }

  _setConversations(List<Conversation> conversations) {
    conversations.forEach((element) {
      element.messages.sort();
    });

    conversations.sort();

    _conversationsSubject.sink.add(conversations);
  }

  _addConversation(Conversation conversation) {
    var conversations = _conversationsSubject.value;
    if (conversations.contains(conversation)) return;
    conversations.add(conversation);
    conversations.sort();
    _conversationsSubject.sink.add(conversations);
  }

  _setConversationMessages(int conversationId, List<Message> messages) {
    messages.sort();
    if (messages.isNotEmpty) _markAsSeen(messages.last);

    if (conversationId == this._conversationId)
      _singleConversationSubject.sink.add(messages);

    var conversations = _conversationsSubject.value;
    if (conversations.isEmpty) {
      return;
    }
    var conversationIndex =
        conversations.indexWhere((element) => element.id == conversationId);

    var conversation = conversations[conversationIndex];
    conversations[conversationIndex].messages = messages;
    conversations.removeWhere((element) {
      return element.messages.isEmpty;
    });
    conversations.sort();

    _conversationsSubject.sink.add(conversations);
  }

  _addNewMessage(int conversationId, Message message) {
    List<Message> messages = _getMessagesByConversaton(conversationId);

    if (messages.contains(message)) return;
    messages.add(message);

    _setConversationMessages(conversationId, messages);
  }

  _markAsSeen(Message message) {
    if (message.isSent || _conversationId != message.conversation_id) return;
    message.seen = true;
    chedMedApi.markAsSeen(message.id).catchError((Object error) async {
      if (error.runtimeType != DioError) return;
      print("error retrying .....");
      await Future.delayed(Duration(seconds: 3));
      _markAsSeen(message);
    });
  }

  Future<Conversation> _createConversation(int receipientId) async {
    return chedMedApi
        .createOrGetConversation(ConversationRequest(recipientId: receipientId))
        .then((value) {
      return value;
    }).catchError((Object error) async {
      print("conx error retry .....");
      await Future.delayed(Duration(seconds: 3));

      return _createConversation(receipientId);
    });
  }
}

final ChatBloc chatBloc = ChatBloc();
