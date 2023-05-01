import 'dart:developer';

import 'package:chatgpt_course/screens/image_upload_screen.dart';
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
  int dropdownValue = 1;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
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

  void changeImageQuantity(int value) {
    dropdownValue = value;
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    // final modelsProvider = Provider.of<ModelsProvider>(context);
    // final chatProvider = Provider.of<ChatProvider>(context);
    final imagesProvider = Provider.of<ImagesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("ChatGPT"),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await Services.showModalSheet(context: context);
        //     },
        //     icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded(child: Container(color: Colors.grey)),
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
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
            Material(
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
                    // ImageQuantity(dropdownValue, changeImageQuantity),
                    IconButton(
                      onPressed: () {
                        // print(dropdownValue);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageUploadScreen()));
                      },
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
          ],
        ),
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

  // void showBottomImageNumber() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       int dropdownValue = 1;
  //       return DropdownButton<int>(
  //         // Step 3.
  //         value: dropdownValue,
  //         // Step 4.
  //         items: <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
  //           return DropdownMenuItem<int>(
  //             value: value,
  //             child: Text(
  //               value.toString(),
  //               style: TextStyle(fontSize: 30),
  //             ),
  //           );
  //         }).toList(),
  //         // Step 5.
  //         onChanged: (int? newValue) {
  //           setState(() {
  //             dropdownValue = newValue!;
  //           });
  //         },
  //       );
  //     },
  //   );
  // }
}

class ImageQuantity extends StatefulWidget {
  int dropdownValue;
  final Function changeDropDownValue;
  ImageQuantity(this.dropdownValue, this.changeDropDownValue);

  @override
  State<ImageQuantity> createState() => _ImageQuantityState();
}

class _ImageQuantityState extends State<ImageQuantity> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      // Step 3.
      value: widget.dropdownValue,
      // Step 4.
      items: <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 30),
          ),
        );
      }).toList(),
      // Step 5.
      onChanged: (int? newValue) {
        setState(() {
          widget.dropdownValue = newValue!;
        });
        widget.changeDropDownValue(newValue);
      },
    );
  }
}
