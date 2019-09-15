import 'package:aniradime/model/radio_program.dart';
import 'package:aniradime/repository/radio_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RadioProgram> _radioPrograms = new List<RadioProgram>();

  @override
  void initState() {
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('aniradime'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
            itemBuilder: (context, index) {
              RadioProgram radioProgram = _radioPrograms[index];
              return Column(
                children: <Widget>[
                  new ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    trailing: Image.network(
                      radioProgram.imageUrl,
                      height: 56,
                    ),
                    title: Text(radioProgram.title),
                    subtitle: Text(radioProgram.description),
                    onTap: () => {launch(radioProgram.url)},
                  ),
                  new Divider(height: 1.0)
                ],
              );
            },
            itemCount: _radioPrograms.length),
        onRefresh: _refresh,
      ),
    );
  }

  Future<void> _refresh() {
    return RadioRepository.load().then((radioPrograms) => {
          setState(() {
            _radioPrograms = radioPrograms;
          })
        });
  }
}
