import 'package:flutter/material.dart';

import './chat_screen.dart';
import './image_screen.dart';

class TextImageTabsScreen extends StatefulWidget {
  const TextImageTabsScreen({super.key});

  @override
  State<TextImageTabsScreen> createState() => _TextImageTabsScreenState();
}

class _TextImageTabsScreenState extends State<TextImageTabsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabcontroller = TabController(length: 2, vsync: this);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              // height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                    blurRadius: 20,
                    spreadRadius: 20,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabcontroller,
                isScrollable: false,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                tabs: [
                  Tab(
                    child: Text('Text'),
                  ),
                  Tab(
                    child: Text('Image'),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabcontroller,
                children: [
                  ChatScreen(),
                  ImageScreen(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
