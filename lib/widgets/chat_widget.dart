import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'text_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        crossAxisAlignment:
            chatIndex == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            shadowColor: Color(0xffcdf0fb),
            elevation: 5,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: chatIndex == 0 ? cardColor : scaffoldBackgroundColor,
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 2 / 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      chatIndex == 0
                          ? AssetsManager.userImage
                          : AssetsManager.botImage,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: chatIndex == 0
                        ? TextWidget(
                            label: msg,
                          )
                        : shouldAnimate
                            ? DefaultTextStyle(
                                style: const TextStyle(
                                    color: Color(0xffcdf0fb),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                                child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    repeatForever: false,
                                    displayFullTextOnTap: true,
                                    totalRepeatCount: 1,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        msg.trim(),
                                      ),
                                    ]),
                              )
                            : Text(
                                msg.trim(),
                                style: const TextStyle(
                                    color: Color(0xffcdf0fb),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FlutterTts flutterTts = FlutterTts();
                      flutterTts.setLanguage("en-US");
                      flutterTts.setPitch(1.5);
                      flutterTts.setSpeechRate(0.5);
                      await flutterTts.speak(
                        msg.toString(),
                      );
                    },
                    child: Icon(
                      Icons.mic,
                      color: Color(0xffcdf0fb),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
