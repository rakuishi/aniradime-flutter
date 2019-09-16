import 'package:aniradime/model/radio_station.dart';
import 'package:aniradime/ui/radio_program_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RadioStation> _radioStations = RadioStation.createRadioStations();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _radioStations.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _radioStations.map((item) => Tab(text: item.title)).toList(),
            isScrollable: _radioStations.length > 3,
          ),
          title: Text('aniradime'),
        ),
        body: TabBarView(
          children:
              _radioStations.map((item) => RadioProgramListPage(item)).toList(),
        ),
      ),
    );
  }
}
