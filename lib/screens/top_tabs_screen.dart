import 'package:flutter/material.dart';

class TopTabsScreen extends StatefulWidget {
  const TopTabsScreen({super.key});

  @override
  State<TopTabsScreen> createState() => _TopTabsScreenState();
}

class _TopTabsScreenState extends State<TopTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Top Tabs Screen')));
  }
}
