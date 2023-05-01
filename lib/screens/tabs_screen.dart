import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import './chat_screen.dart';
import './image_screen.dart';
import './text_recognition.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Widget> _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      ChatScreen(),
      ImageScreen(),
      TextRecognition(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 0,
        ),
        // margin: EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, -7),
              color: Color.fromRGBO(0, 0, 0, 0.06),
            ),
          ],
        ),
        child: BottomNavigationBar(
          unselectedFontSize: 0,
          selectedFontSize: 0,
          onTap: _selectPage,
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          currentIndex: _selectedPageIndex,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: ActiveIcon(
                iconData: Icons.home_outlined,
                title: 'Text Chat',
              ),
              icon: InactiveIcon(
                iconData: Icons.home_outlined,
                title: 'Text Chat',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: ActiveIcon(
                iconData: Icons.dashboard_outlined,
                title: 'Image',
              ),
              icon: InactiveIcon(
                iconData: Icons.dashboard_outlined,
                title: 'Image',
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: ActiveIcon(
                iconData: Icons.dashboard_outlined,
                title: 'Get Text',
              ),
              icon: InactiveIcon(
                iconData: Icons.dashboard_outlined,
                title: 'Get Text',
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class InactiveIcon extends StatelessWidget {
  IconData iconData;
  String title;
  InactiveIcon({required this.iconData, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 38,
      decoration: const BoxDecoration(
          // color: Colors.blue,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: Color.fromRGBO(66, 143, 212, 1),
            size: 20,
          ),
          const SizedBox(width: 7),
          Text(
            title,
            style: const TextStyle(
              color: Color.fromRGBO(66, 143, 212, 1),
              fontSize: 12,
              fontFamily: 'Montserrat',
              // fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveIcon extends StatelessWidget {
  IconData iconData;
  String title;
  ActiveIcon({required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 38,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(66, 143, 212, 1),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 7),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
