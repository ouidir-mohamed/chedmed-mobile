import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chedmed/blocs/chat_bloc.dart';
import 'package:chedmed/models/conversation_user.dart';
import 'package:chedmed/models/message.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/discussions/chat_bubble_presentation.dart';

import '../../utils/vibration.dart';
import '../common/inputs.dart';
import 'chat_bubble.dart';

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

class MessageBox extends StatefulWidget {
  int userId;
  int? conversationId;

  MessageBox({
    Key? key,
    required this.userId,
    required this.conversationId,
  }) : super(key: key) {}

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  late TextEditingController _textController;
  bool _displayMicrophone = true;
  bool _recordingStarted = false;

  late RecorderController recorderController;

  @override
  void initState() {
    recorderController = RecorderController();

    _textController = TextEditingController();
    _textController.addListener(() {
      chatBloc.startTyping(widget.userId);
      if (_textController.text.isEmpty) {
        setState(() {
          _displayMicrophone = true;
        });
      } else {
        if (_displayMicrophone) {
          setState(() {
            _displayMicrophone = false;
          });
        }
      }
    });
    super.initState();
  }

  startRecording() async {
    vibrateThePhone();

    setState(() {
      _recordingStarted = true;
    });
    recorderController.reset();

    startRecordingTime = DateTime.now();

    await recorderController.record();
  }

  stopRecording() async {
    setState(() {
      _recordingStarted = false;
    });
    var record = await recorderController.stop();
    if (record == null) return;
    print(record);
    chatBloc.sendVocalMessage(
        widget.userId, record, getRecordedDuration().inSeconds);
  }

  cancelRecording() async {
    vibrateThePhone();
    setState(() {
      _recordingStarted = false;
    });
    var record = await recorderController.stop();
  }

  bool stopRecordingHovered = false;

  voiceMessageButtonReleased() {
    isPointerInsideStopRecordingButton() ? cancelRecording() : stopRecording();
  }

  DateTime startRecordingTime = DateTime.now();

  Duration getRecordedDuration() {
    return DateTime.now().difference(startRecordingTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _recordingStarted
              ? VoiceMessageBox(
                  isStopHovered: stopRecordingHovered,
                  recorderController: recorderController,
                  getRemoveButtonOffset: _setVoiceMessageBoxOffset,
                )
              : Container(),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textController,
                  decoration: MyInputDecoration(
                      title: "Nouveau message", context: context),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              !_displayMicrophone
                  ? InkWell(
                      onTap: () {
                        if (_textController.text.isEmpty) return;
                        chatBloc.sendTextMessage(
                          widget.userId,
                          _textController.text,
                        );
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
                  : VoiceMessageButton(
                      onTap: startRecording,
                      onRelease: voiceMessageButtonReleased,
                      onMove: _onVoiceMessageButtonPointerMove,
                    )
            ],
          ),
        ],
      ),
    );
  }

  late Offset voiceMessageBoxOffset;
  late double x1, x2, y1, y2;
  double STOP_RECORDING_BUTTON_SIZE = 40;
  _setVoiceMessageBoxOffset(Offset offset) {
    x1 = offset.dx;
    x2 = x1 + STOP_RECORDING_BUTTON_SIZE;
    y1 = offset.dy;
    y2 = y1 + STOP_RECORDING_BUTTON_SIZE;
  }

  _onVoiceMessageButtonPointerMove(Offset offset) {
    voiceMessageBoxOffset = offset;

    setState(() {
      stopRecordingHovered = isPointerInsideStopRecordingButton();
    });
  }

  bool isPointerInsideStopRecordingButton() {
    try {
      return (voiceMessageBoxOffset.dx > x1 &&
          voiceMessageBoxOffset.dx < x2 &&
          voiceMessageBoxOffset.dy > y1 &&
          voiceMessageBoxOffset.dy < y2);
    } catch (e) {
      return false;
    }
  }
}

class VoiceMessageButton extends StatelessWidget {
  void Function() onTap;
  void Function() onRelease;
  void Function(Offset offset) onMove;

  VoiceMessageButton({
    Key? key,
    required this.onTap,
    required this.onRelease,
    required this.onMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Listener(
          onPointerDown: (p) async {
            await Future.delayed(Duration(milliseconds: 500));
            onTap();
          },
          onPointerMove: (p) {
            onMove(p.position);
          },
          onPointerUp: (p) {
            print("up");
            onRelease();
          },
          // excludeFromSemantics: true,
          // onTap: () {},
          // onLongPress: () {
          //   startRecording();
          // },
          // onLongPressUp: () {
          //   stopRecording();
          // },
          // onPanUpdate: (d) {
          //   print(d.globalPosition);
          // },
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
                color: AppTheme.primaryColor(context),
                borderRadius: BorderRadius.circular(80)),
            child: Icon(
              Ionicons.mic,
              color: Colors.white,
              size: 20,
            ),
          )),
    );
  }
}

class VoiceMessageBox extends StatefulWidget {
  RecorderController recorderController;
  void Function(Offset offset) getRemoveButtonOffset;
  bool isStopHovered;
  VoiceMessageBox({
    Key? key,
    required this.recorderController,
    required this.getRemoveButtonOffset,
    required this.isStopHovered,
  }) : super(key: key);

  @override
  State<VoiceMessageBox> createState() => _VoiceMessageBoxState();
}

class _VoiceMessageBoxState extends State<VoiceMessageBox> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        widget.getRemoveButtonOffset(position);
      });
    });

    widget.recorderController.addListener(() {
      if (widget.recorderController.waveData.last < 0) {
        widget.recorderController.waveData.last = 0;
      }

      if (widget.recorderController.isRecording != isRecording) {
        isRecording = widget.recorderController.isRecording;
        if (isRecording) startDurationCounter();
      }
    });
    super.initState();
  }

  Duration _recordedDuration = Duration(seconds: 0);
  bool isRecording = false;
  startDurationCounter() async {
    print('rec');
    if (!isRecording) return;
    await Future.delayed(Duration(seconds: 1));
    if (mounted)
      setState(() {
        _recordedDuration = _recordedDuration + Duration(seconds: 1);
      });

    startDurationCounter();
  }

  @override
  Widget build(BuildContext context) {
    super.didChangeDependencies();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(Ionicons.trash,
                  size: 26,
                  color: widget.isStopHovered
                      ? Colors.red
                      : AppTheme.primaryColor(context)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: widget.isStopHovered
                    ? Colors.red
                    : AppTheme.primaryColor(context),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                AudioWaveforms(
                  size: Size(MediaQuery.of(context).size.width - 150, 20.0),
                  waveStyle: WaveStyle(
                      waveCap: StrokeCap.round,
                      scaleFactor: 5,
                      extendWaveform: true,
                      showMiddleLine: false,
                      waveThickness: 3,
                      spacing: 5,

                      //showBottom: false,
                      // showTop: false,
                      waveColor: Colors.white),
                  recorderController: widget.recorderController,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(_recordedDuration.toHHMMSS().substring(3))
              ],
            ),
          ),
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
