import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../widgets/text_widget.dart';
import '../providers/models_provider.dart';
import '../providers/images_provider.dart';
import '../services/assets_manager.dart';

import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/services/services.dart';
import 'package:chatgpt_course/widgets/chat_widget.dart';
import 'package:chatgpt_course/widgets/image_widget.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  final ScrollController _controller = ScrollController();
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
    final imagesProvider = Provider.of<ImagesProvider>(context);
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
            // Expanded(child: Container(color: Colors.grey)),
            Flexible(
              child: ListView.builder(
                  controller: _controller,
                  itemCount:
                      imagesProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ImageWidget(
                      msg: imagesProvider
                          .getChatList[index].url, // chatList[index].msg,
                      chatIndex: imagesProvider.getChatList[index]
                          .imgIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          imagesProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  style: const TextStyle(color: Colors.white),
                  controller: textEditingController,
                  onSubmitted: (value) async {
                    await sendPrompt(
                      imagesProvider: imagesProvider,
                    );
                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: "How can I help you",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await sendPrompt(
                    imagesProvider: imagesProvider,
                  );
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
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
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendPrompt({required ImagesProvider imagesProvider}) async {
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
      print(msg);
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        imagesProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });

      await imagesProvider.sendPromptAndGetImage(msg: msg);
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

  void showBottomImageNumber() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          String dropdownValue = '1';
          return DropdownButton<String>(
            // Step 3.
            value: dropdownValue,
            // Step 4.
            items: <String>['1', '2', '3', '4']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 30),
                ),
              );
            }).toList(),
            // Step 5.
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
          );
        });
  }
}
