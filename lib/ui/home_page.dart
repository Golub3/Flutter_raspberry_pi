import 'package:contact_list/ui/tabs/history_tab.dart';
import 'package:contact_list/ui/tabs/stream_tab.dart';
import 'package:flutter/material.dart';
import 'tabs/people_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> tabsList = [
    Tab(
      icon: Icon(Icons.videocam),
      text: "Stream",
    ),
    Tab(
      icon: Icon(Icons.person),
      text: "People",
    ),
    Tab(
      icon: Icon(Icons.history),
      text: "History",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            StreamTab(),
            PeopleTab(),
            HistoryTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelStyle: TextStyle(fontSize: 7, fontFamily: "Helvetica"),
          tabs: tabsList,
          labelColor: Color(0xFFFFFFFF),
          unselectedLabelColor: Color(0xFF909090),
          indicatorColor: Colors.transparent,
        ),
        backgroundColor: Color(0xFF282828),
      ),
    );
  }
}
