import 'package:aniradime/model/radio_program.dart';
import 'package:aniradime/repository/radio_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RadioProgramListPage extends StatefulWidget {
  final String id;

  RadioProgramListPage(this.id);

  @override
  State createState() => _RadioProgramListPage();
}

// Do not rebuild a page after changing a tab
// https://github.com/flutter/flutter/issues/19116
class _RadioProgramListPage extends State<RadioProgramListPage>
    with AutomaticKeepAliveClientMixin<RadioProgramListPage> {
  List<RadioProgram> _radioPrograms = new List<RadioProgram>();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() {
    return RadioRepository.load(widget.id).then((radioPrograms) => {
          setState(() {
            _radioPrograms = radioPrograms;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, index) => _buildListItem(_radioPrograms[index]),
        itemCount: _radioPrograms.length,
      ),
      onRefresh: _refresh,
    );
  }

  Widget _buildListItem(RadioProgram radioProgram) {
    return Column(
      children: <Widget>[
        new ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          trailing: Image.network(radioProgram.imageUrl, height: 56),
          title: Text(radioProgram.title),
          subtitle: Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(radioProgram.formattedDateTime()),
          ),
          onTap: () => {launch(radioProgram.url)},
        ),
        new Divider(height: 1.0)
      ],
    );
  }
}
