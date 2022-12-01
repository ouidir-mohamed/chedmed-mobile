import 'dart:async';

import 'package:chedmed/models/message.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

const BASE_URL = "http://51.77.137.247:5000";

class ChatSocket {
  late Socket _socket;
  PublishSubject<Message> _messagesController = PublishSubject<Message>();
  Stream<Message> get getMessages => _messagesController.stream;

  PublishSubject<void> _typingController = PublishSubject<void>();
  Stream<void> get getTyping => _typingController.stream;

  init(String token) {
    print(token + " " + "use this");
    _socket = io(
        BASE_URL,
        OptionBuilder()
            .setExtraHeaders({"Authorization": "Bearer " + token})
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
  }

  joinConvcersation(int conversationId) {
    print("trynig to join conversation" + conversationId.toString());
    if (_socket.connected) {
      _socket.disconnect();
      _socket.clearListeners();
    }

    _socket.connect();

    _socket.on('connect', (_) {
      print('connect');
      _socket.emit('joinConversation', conversationId);
    });

    _socket.on("message", (data) {
      Message message = Message.fromJson(data);
      print("from socket");

      _messagesController.sink.add(message);
    });

    _socket.on("typing", (data) {
      print("typing");
      _typingController.sink.add(null);
    });

    _socket.on("error", (data) {
      print(data);
    });
  }

  leaveConversation() {
    _socket.disconnect();
    _socket.clearListeners();
  }
}

ChatSocket chatSocket = ChatSocket();
