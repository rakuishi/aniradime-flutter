import 'dart:async';
import 'dart:convert';

import 'package:aniradime/model/radio_program.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RadioRepository {
  static Future<List<RadioProgram>> load(String id) async {
    switch (id) {
      case 'onsen':
      default:
        return loadOnsen();
    }
  }

  static Future<List<RadioProgram>> loadOnsen() async {
    final baseUrl = 'http://www.onsen.ag/';
    final mobileUserAgent =
        'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1';
    final response = await http.get(
      baseUrl,
      headers: {'User-Agent': mobileUserAgent},
    );

    String responseBody = utf8.decode(response.bodyBytes); // latin-1 -> utf8
    final document = parse(responseBody);

    List<RadioProgram> radioPrograms = [];
    document
        .querySelectorAll('div.programContsWrap div.programConts')
        .forEach((div) {
      // print(_parseRadio(div, baseUrl).toString());
      RadioProgram radioProgram = _parseOnsenRadioProgram(div, baseUrl);
      if (radioProgram != null) radioPrograms.add(radioProgram);
    });

    radioPrograms.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return new Future.value(radioPrograms);
  }

  static RadioProgram _parseOnsenRadioProgram(Element div, String baseUrl) {
    String url;
    DateTime dateTime;

    try {
      url = div.querySelector('div.playBtn > form').attributes['action'];

      RegExp exp = new RegExp("^([0-9]{6})[a-zA-Z0-9]+?\.mp[3|4]\$");
      final match =
          exp.firstMatch(url.substring(url.length - 14)); // 190909WE8s.mp3
      var date = match.group(1);
      date =
          "20${date.substring(0, 2)}/${date.substring(2, 4)}/${date.substring(4, 6)}";
      dateTime = new DateFormat('yyyy/MM/dd').parse(date);
    } catch (e) {
      return null;
    }

    return new RadioProgram(
        div.querySelector('div.programData > p.programTitle').text,
        div.querySelector('div.programData > p.programPersonality').text,
        url,
        baseUrl + div.querySelector('div.programLogo > img').attributes['src'],
        dateTime);
  }
}
