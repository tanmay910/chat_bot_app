import 'package:chatgpt_course/screens/top_tabs_screen.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../services/services.dart';

class TopBarScreen extends StatefulWidget {
  const TopBarScreen({Key? key}) : super(key: key);

  @override
  State<TopBarScreen> createState() => _TopBarScreenState();
}

class _TopBarScreenState extends State<TopBarScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: TopTabsScreen(),);
  }
}
