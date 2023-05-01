import 'package:chatgpt_course/screens/text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../constants/constants.dart';
import 'chat_screen.dart';
import 'image_screen.dart';

class TopTabsScreen extends StatefulWidget {
  const TopTabsScreen({super.key});

  @override
  State<TopTabsScreen> createState() => _TopTabsScreenState();
}

class _TopTabsScreenState extends State<TopTabsScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[    ChatScreen(),   ImageScreen(),   TextRecognition() ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: null,
      // Removed the bottomNavigationBar
      // Added a new AppBar with the GoogleNavBar widget
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: scaffoldBackgroundColor,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Color(0xffcdf0fb),
          tabs: [
            GButton(
              icon: Icons.wechat_sharp,
              text: 'Chats',
            ),
            GButton(
              icon: Icons.image_rounded,
              text: 'Images',
            ),
            GButton(
              icon: Icons.document_scanner_rounded,
              text: 'Scan',
            ),

          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
