import 'dart:developer';
import 'package:chatgpt_course/screens/text_recognition.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/services/services.dart';
import 'package:chatgpt_course/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool _isListening = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  final speech = stt.SpeechToText();
  double _buttonSize = 50.0;
  double _borderRadius = 25.0;
  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(),
        ),
        elevation: 5,
        backgroundColor: scaffoldBackgroundColor,
        shadowColor: Color(0xffcdf0fb),
        leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/sharingan.png')),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "ChatGPT",
            style: TextStyle(color: Color(0xffcdf0fb)),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xffcdf0fb)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _controller,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Color(0xffcdf0fb),
                size: 18,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        shadowColor: Color(0xffcdf0fb),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0xffcdf0fb), width: 1)),
        color: scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  style: const TextStyle(color: Color(0xffcdf0fb)),
                  controller: textEditingController,
                  onSubmitted: (value) async {
                    await sendMessageFCT(
                        modelsProvider: modelsProvider,
                        chatProvider: chatProvider);
                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: "How can I help you",
                      hintStyle: TextStyle(color: Color(0xffcdf0fb))),
                ),
              ),
              GestureDetector(
                  onTapUp: (details) {
                    speech.stop();
                    setState(() {
                      _isListening = false;
                    });
                  },
                  onTapDown: (details) async {
                    final isAvailable = await speech.initialize();
                    if (isAvailable) {
                      setState(() {
                        _isListening = true;
                      });
                      await speech.listen(
                        onResult: (result) {
                          textEditingController.text = result.recognizedWords;
                        },
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.mic,
                        color: _isListening ? Colors.blue : Color(0xffcdf0fb),
                      ),
                      if (_isListening)
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () async {
                    await sendMessageFCT(
                        modelsProvider: modelsProvider,
                        chatProvider: chatProvider);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xffcdf0fb),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollDown,
        child: Icon(Icons.arrow_downward),
        backgroundColor: Color(0xffcdf0fb),
        foregroundColor: Color(0xff161621),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
