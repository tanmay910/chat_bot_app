import 'package:flutter/cupertino.dart';

import '../models/chat_model.dart';
import '../models/image_model.dart';
import '../services/api_service.dart';

class ImagesProvider with ChangeNotifier {
  List<ImageModel> chatList = [];
  List<ImageModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ImageModel(url: msg, imgIndex: 0));
    notifyListeners();
  }

  Future<void> sendPromptAndGetImage(
      {required String msg}) async {
        chatList.addAll(await ApiService.sendImagePromptAndGetImage(
        message: msg,
        n: 1,
        size: '1024x1024'
      ));
    notifyListeners();
  }
}
