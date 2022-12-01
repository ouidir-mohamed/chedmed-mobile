import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chedmed/blocs/chat_bloc.dart';
import 'package:chedmed/models/conversation_user.dart';
import 'package:chedmed/models/message.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/discussions/chat_bubble_presentation.dart';

import '../common/inputs.dart';

class DiscussionDetils extends StatefulWidget {
  int? conversationId;
  String userName;
  int userId;
  DiscussionDetils({
    Key? key,
    required this.conversationId,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  State<DiscussionDetils> createState() => _DiscussionDetilsState();
}

class _DiscussionDetilsState extends State<DiscussionDetils> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    chatBloc.startConversation(widget.conversationId, widget.userId);
    controller.addListener(() {
      if (controller.position.atEdge) {
        chatBloc.requestOlderMessages(widget.conversationId!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            UserInfo(
              userId: widget.userId,
              userName: widget.userName,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DiscussionBubbles(),
                  ],
                ),
              ),
            ),
            MessageBox(
              userId: widget.userId,
              conversationId: widget.conversationId,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  int userId;
  int? conversationId;
  late TextEditingController _textController;
  MessageBox({
    Key? key,
    required this.userId,
    required this.conversationId,
  }) : super(key: key) {
    _textController = TextEditingController();
    _textController.addListener(() {
      chatBloc.startTyping(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              decoration:
                  MyInputDecoration(title: "Nouveau message", context: context),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                if (_textController.text.isEmpty) return;
                chatBloc.sendMessage(userId, _textController.text);
                _textController.text = "";
              },
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: AppTheme.primaryColor(context),
                    borderRadius: BorderRadius.circular(80)),
                child: Icon(
                  Ionicons.ios_send,
                  color: Colors.white,
                  size: 20,
                ),
              ))
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  String userName;
  int userId;
  UserInfo({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.cardColor(context),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              AntDesign.arrowleft,
              color: AppTheme.primaryColor(context),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: // AppTheme.headlineColor(context).withOpacity(0.2)
                    AppTheme.primaryColor(context)),
            child: Text(
              userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: AppTheme.containerColor(context)),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            userName,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}

class DiscussionBubbles extends StatefulWidget {
  DiscussionBubbles({Key? key}) : super(key: key);

  @override
  State<DiscussionBubbles> createState() => _DiscussionBubblesState();
}

class _DiscussionBubblesState extends State<DiscussionBubbles> {
  List<DiscussionBubble> bubbles = [];
  late StreamSubscription disposable;
  @override
  void initState() {
    disposable = chatBloc.getSingleConversation.listen((event) {
      if (mounted)
        setState(() {
          bubbles = ChatBubblePresentation.fromMessages(event)
              .map((e) => DiscussionBubble(bubble: e))
              .toList();
        });
    });
    print(disposable);
    super.initState();
  }

  @override
  void dispose() {
    chatBloc.leaveConversation();
    disposable.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: bubbles,
        ),
        TypingBubble()
      ],
    );
  }
}

class TypingBubble extends StatefulWidget {
  const TypingBubble({Key? key}) : super(key: key);

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble> {
  bool isTyping = false;
  int typingCount = 0;
  startTyping() async {
    typingCount++;

    if (mounted) ;
    setState(() {
      isTyping = true;
    });
    await Future.delayed(Duration(seconds: 3));
    typingCount--;

    if (typingCount == 0 && mounted)
      setState(() {
        isTyping = false;
      });
  }

  stopTyping() {
    typingCount = 0;
    if (mounted)
      setState(() {
        isTyping = false;
      });
  }

  @override
  void initState() {
    chatBloc.getTyping.listen((typing) {
      if (typing)
        startTyping();
      else
        stopTyping();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isTyping
        ? Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 15, bottom: 8, right: 8, left: 8),
              child: Container(
                child: Text("En train d'écrire ..."),
              ),
            ),
          )
        : Container();
  }
}

class DiscussionBubble extends StatelessWidget {
  ChatBubblePresentation bubble;
  DiscussionBubble({
    Key? key,
    required this.bubble,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        bubble.timeHeader.isNotEmpty ? Text(bubble.timeHeader) : Container(),
        Align(
          alignment: bubble.type == MessageType.SENT
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          child: Opacity(
            opacity: bubble.pending ? 0.7 : 1,
            child: Container(
              margin: bubble.type == MessageType.SENT
                  ? EdgeInsets.only(left: 100)
                  : EdgeInsets.only(right: 100),
              child: Container(
                margin: EdgeInsets.only(
                    right: 15, left: 15, top: bubble.hasMarginTop ? 5 : 2.5),
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bubble.type == MessageType.SENT
                      ? AppTheme.primaryColor(context)
                      : AppTheme.cardColor(context),
                ),
                child: Text(bubble.content,
                    style: TextStyle(
                        color: bubble.type == MessageType.SENT
                            ? Colors.white
                            : AppTheme.textColor(context),
                        fontSize: 15)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
