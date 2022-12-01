import 'package:chedmed/models/conversation.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'package:chedmed/blocs/chat_bloc.dart';
import 'package:chedmed/ui/discussions/discussion_details.dart';
import 'package:chedmed/utils/time_formatter.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../common/app_theme.dart';
import '../common/scroll_view.dart';
import 'conversation_presentation.dart';

class DiscussionsScreen extends StatefulWidget {
  const DiscussionsScreen({Key? key}) : super(key: key);

  @override
  State<DiscussionsScreen> createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  List<ConversationPresentation> conversations = [];

  @override
  void initState() {
    chatBloc.loadAllConversations();
    chatBloc.getConvesations.listen((event) {
      // print(event.firstWhere((element) => element.id == 22).messages.last);
      if (mounted)
        setState(() {
          conversations = event
              .map((e) {
                return ConversationPresentation.fromConversation(e);
              })
              .toList()
              .whereType<ConversationPresentation>()
              .toList();
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Header(),
            backgroundColor: AppTheme.canvasColor(context),
            elevation: 0,
          ),
          body: MessagesList(
            conversations: conversations,
          )),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Discussions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  List<ConversationPresentation> conversations;
  MessagesList({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: () async {
          chatBloc.loadAllConversations();
        },
        child: FullHeightScrollView(
          child: Column(
            children: conversations
                .map((e) => ConversationItem(conversation: e))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ConversationItem extends StatelessWidget {
  ConversationPresentation conversation;
  ConversationItem({Key? key, required this.conversation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DiscussionDetils(
                      conversationId: conversation.id,
                      userId: conversation.userId,
                      userName: conversation.username,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: // AppTheme.headlineColor(context).withOpacity(0.2)
                    AppTheme.primaryColor(context)),
            child: Text(
              conversation.username.substring(0, 1).toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: AppTheme.containerColor(context)),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.username,
                        style: TextStyle(
                            color: conversation.seenByUser
                                ? AppTheme.headlineColor(context)
                                : AppTheme.textColor(context),
                            fontSize: 16,
                            fontWeight: conversation.seenByUser
                                ? FontWeight.normal
                                : FontWeight.bold),
                      ),
                    ),
                    Text(conversation.time,
                        style: TextStyle(
                            color: conversation.seenByUser
                                ? AppTheme.headlineColor(context)
                                : AppTheme.textColor(context),
                            fontWeight: conversation.seenByUser
                                ? FontWeight.normal
                                : FontWeight.bold))
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    conversation.seenByReceiver
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Ionicons.checkmark_done_sharp,
                              color: AppTheme.headlineColor(context),
                              size: 15,
                            ),
                          )
                        : Container(),
                    Text(conversation.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: conversation.seenByUser
                                ? AppTheme.headlineColor(context)
                                : AppTheme.textColor(context),
                            fontWeight: conversation.seenByUser
                                ? FontWeight.normal
                                : FontWeight.bold)),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
