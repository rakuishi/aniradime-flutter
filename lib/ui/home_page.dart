import 'package:aniradime/model/tab_item.dart';
import 'package:aniradime/ui/radio_program_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabItem> _tabItems = TabItem.createTabItems();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabItems.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _tabItems.map((item) => Tab(text: item.title)).toList(),
          ),
          title: Text('aniradime'),
        ),
        body: TabBarView(
          children: _tabItems.map((item) => RadioProgramListPage(item.id)).toList(),
        ),
      ),
    );
  }
}
