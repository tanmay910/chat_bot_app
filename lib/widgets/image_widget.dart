import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_downloader/image_downloader.dart';

import 'text_widget.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : Container(
                          child: Column(
                            children: [
                              Image.network(
                                msg,
                                fit: BoxFit.fitWidth,
                              ),
                              IconButton(
                                // onPressed: () async {
                                //   final tempDir =
                                //       await await GallerySaver.saveImage(msg,
                                //           albumName: 'Flutter');

                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //           content:
                                //               Text('Downloaded to Gallery')));
                                // },
                                onPressed: () => downloadImage(msg),
                                icon: Icon(Icons.file_download_outlined),
                              ),
                            ],
                          ),
                        ),
                  // : Container(
                  //     child: Stack(
                  //       children: [
                  //         Container(
                  //           child: Image.network(
                  //             msg,
                  //             fit: BoxFit.fitWidth,
                  //           ),
                  //         ),
                  //         Column(
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 const Spacer(),
                  //                 IconButton(
                  //                   onPressed: () async {
                  //                     await GallerySaver.saveImage(msg,
                  //                         albumName: 'Flutter');
                  //                   },
                  //                   icon:
                  //                       Icon(Icons.file_download_outlined),
                  //                 ),
                  //               ],
                  //             ),
                  //             const Spacer(),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // : shouldAnimate
                  //     ? DefaultTextStyle(
                  //         style: const TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w700,
                  //             fontSize: 16),
                  //         child: AnimatedTextKit(
                  //             isRepeatingAnimation: false,
                  //             repeatForever: false,
                  //             displayFullTextOnTap: true,
                  //             totalRepeatCount: 1,
                  //             animatedTexts: [
                  //               TyperAnimatedText(
                  //                 msg.trim(),
                  //               ),
                  //             ]),
                  //       )
                  //     : Text(
                  //         msg.trim(),
                  //         style: const TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w700,
                  //             fontSize: 16),
                  //       ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void downloadImage(String url) async {
    Dio dio = Dio();
    String fileName = url.substring(url.length - 15);
    print(fileName);
    String path = await _getFilePath(fileName);
    print(path);

    await dio.download(
      url,
      path,
    );

    // await GallerySaver.saveImage(url, albumName: 'Flutter');
    // await GallerySaver.saveImage(url, toDcim: true, albumName: 'Flutter');
    // ImageDownloader.downloadImage(url);
  }

  Future<String> _getFilePath(String filename) async {
    // final dir = await getApplicationDocumentsDirectory();
    // return "${dir.path}/$filename";
    return "/storage/emulated/0/DCIM/temp/$filename";
  }
}
