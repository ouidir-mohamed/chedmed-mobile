import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'package:chedmed/models/message_type.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:path_provider/path_provider.dart';

import '../../blocs/chat_bloc.dart';
import '../common/app_theme.dart';
import 'chat_bubble_presentation.dart';

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
          alignment: bubble.direction == MessageDirection.SENT
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          child: Opacity(
            opacity: bubble.pending ? 0.7 : 1,
            child: Container(
              margin: bubble.direction == MessageDirection.SENT
                  ? EdgeInsets.only(left: 100)
                  : EdgeInsets.only(right: 100),
              child: Container(
                margin: EdgeInsets.only(
                    right: 15, left: 15, top: bubble.hasMarginTop ? 7 : 4.5),
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bubble.direction == MessageDirection.SENT
                      ? AppTheme.primaryColor(context)
                      : AppTheme.cardColor(context),
                ),
                child: bubble.type == MessageType.VOCAL
                    ? AudioBubble(
                        mediaPath: bubble.voicePath!,
                        mediaDuration: bubble.voiceDuration!,
                      )
                    : Text(bubble.content,
                        style: TextStyle(
                            color: bubble.direction == MessageDirection.SENT
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

class AudioBubble extends StatefulWidget {
  String mediaPath;
  int mediaDuration;

  AudioBubble({
    Key? key,
    required this.mediaPath,
    required this.mediaDuration,
  }) : super(key: key);

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  PlayerController playerController = PlayerController();

  late Duration durationLeft = Duration(seconds: widget.mediaDuration);
  preparePlayer() async {
    try {
      await playerController.preparePlayer(widget.mediaPath);
    } catch (e) {
      File file = await urlToFile(widget.mediaPath);

      await playerController.preparePlayer(file.path);
      print("catched");
    }
    playerController.onCurrentDurationChanged.listen((event) {
      if (mounted)
        setState(() {
          durationLeft = Duration(seconds: widget.mediaDuration) -
              Duration(milliseconds: event);
        });
    });
  }

  bool isReady = false;
  bool isPlaying = false;

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    preparePlayer();
    playerController.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.initialized) {
        setState(() {
          isReady = true;
        });
      }
      if (event == PlayerState.paused || event == PlayerState.stopped) {
        setState(() {
          isPlaying = false;
        });
      }

      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            !isPlaying
                ? playerController.startPlayer(finishMode: FinishMode.pause)
                : playerController.pausePlayer();
          },
          child: !isPlaying ? Icon(Ionicons.play) : Icon(Ionicons.pause),
        ),
        isReady
            ? Row(
                children: [
                  AudioFileWaveforms(
                      enableSeekGesture: true,
                      size: Size(MediaQuery.of(context).size.width - 214, 40.0),
                      playerController: playerController,
                      density: 2.3,
                      playerWaveStyle: PlayerWaveStyle(
                        waveCap: StrokeCap.round,

                        scaleFactor: 0.2,
                        waveThickness: 2.8,
                        fixedWaveColor: Colors.white30,
                        liveWaveColor: Colors.white,

                        //showBottom: false,
                        // showTop: false,
                      )),
                  SizedBox(
                    width: 4,
                  ),
                  Text(durationLeft.toHHMMSS().substring(3)),
                ],
              )
            : SizedBox(
                height: 40,
              ),
      ],
    );
  }
}

Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}
