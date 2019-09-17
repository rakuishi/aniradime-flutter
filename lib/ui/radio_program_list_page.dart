import 'package:aniradime/model/radio_program.dart';
import 'package:aniradime/model/radio_station.dart';
import 'package:aniradime/repository/radio_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class RadioProgramListPage extends StatefulWidget {
  final RadioStation radioStation;

  RadioProgramListPage(this.radioStation);

  @override
  State createState() => _RadioProgramListPage();
}

// Do not rebuild a page after changing a tab
// https://github.com/flutter/flutter/issues/19116
class _RadioProgramListPage extends State<RadioProgramListPage>
    with AutomaticKeepAliveClientMixin<RadioProgramListPage> {
  List<RadioProgram> _radioPrograms = new List<RadioProgram>();
  bool _isRefreshing = false;

  bool _showProgress() => _isRefreshing && _radioPrograms.length == 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() {
    _isRefreshing = true;
    return RadioRepository.load(widget.radioStation).then((radioPrograms) {
      _isRefreshing = false;
      setState(() {
        _radioPrograms = radioPrograms;
      });
    }).catchError((onError) {
      _isRefreshing = false;
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_showProgress()) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (context, index) =>
              _buildListItem(_radioPrograms[index]),
          itemCount: _radioPrograms.length,
        ),
        onRefresh: _refresh,
      );
    }
  }

  Widget _buildListItem(RadioProgram radioProgram) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          radioProgram.title,
                          style: Theme.of(context).primaryTextTheme.subhead,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          radioProgram.formattedDateTime(),
                          style: Theme.of(context).primaryTextTheme.body1,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Image.network(
                    radioProgram.imageUrl,
                    height: 68,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.0)
        ],
      ),
      onTap: () => {launch(radioProgram.url)},
    );
  }
}
