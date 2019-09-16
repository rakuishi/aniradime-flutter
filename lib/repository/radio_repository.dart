import 'dart:async';
import 'dart:convert';

import 'package:aniradime/model/radio_program.dart';
import 'package:aniradime/model/radio_station.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

class RadioRepository {
  static Future<List<RadioProgram>> load(RadioStation radioStation) async {
    switch (radioStation.type) {
      case 'onsen':
        return _loadOnsen(radioStation);
      case 'chnicovideo':
        return _loadChNicoVideo(radioStation);
      default:
        throw Exception("${radioStation.title} is not supported.");
    }
  }

  static Future<List<RadioProgram>> _loadOnsen(
      RadioStation radioStation) async {
    final baseUrl = radioStation.url;
    final mobileUserAgent =
        'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1';
    final response = await http.get(
      radioStation.source,
      headers: {'User-Agent': mobileUserAgent},
    );

    final String responseBody =
        utf8.decode(response.bodyBytes); // latin-1 -> utf8
    final document = parse(responseBody);
    final List<RadioProgram> radioPrograms = [];

    document
        .querySelectorAll('div.programContsWrap div.programConts')
        .forEach((div) {
      // print(_parseRadio(div, baseUrl).toString());
      final RadioProgram radioProgram = _parseOnsenRadioProgram(div, baseUrl);
      if (radioProgram != null) radioPrograms.add(radioProgram);
    });

    radioPrograms.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Future.value(radioPrograms);
  }

  static RadioProgram _parseOnsenRadioProgram(Element div, String baseUrl) {
    String url;
    DateTime dateTime;

    try {
      url = div.querySelector('div.playBtn > form').attributes['action'];

      final RegExp exp = RegExp("^([0-9]{6})[a-zA-Z0-9]+?\.mp[3|4]\$");
      final match =
          exp.firstMatch(url.substring(url.length - 14)); // 190909WE8s.mp3
      var date = match.group(1);
      date =
          "20${date.substring(0, 2)}/${date.substring(2, 4)}/${date.substring(4, 6)}";
      dateTime = DateFormat('yyyy/MM/dd').parse(date);
    } catch (e) {
      return null;
    }

    return RadioProgram(
        div.querySelector('div.programData > p.programTitle').text,
        div.querySelector('div.programData > p.programPersonality').text,
        url,
        baseUrl + div.querySelector('div.programLogo > img').attributes['src'],
        dateTime);
  }

  static Future<List<RadioProgram>> _loadChNicoVideo(
      RadioStation radioStation) async {
    final response = await http.get(radioStation.source);
    final document = xml.parse(response.body);
    final List<RadioProgram> radioPrograms = [];

    document.findAllElements('item').forEach((item) {
      final dateTime = DateFormat('EEE, d MMM yyyy HH:mm:ss Z')
          .parse(item.findElements('pubDate').single.text);

      final description = item.findElements('description').single.text;

      final RegExp imgExp = RegExp("<img alt=\".+?\" src=\"(.+?)\" .+?/>");
      final imgMatch = imgExp.firstMatch(description);

      final RegExp descExp = RegExp("<p class=\"nico-description\">(.+?)</p>");
      final descMatch = descExp.firstMatch(description);

      radioPrograms.add(RadioProgram(
          item.findElements('title').single.text,
          descMatch.group(1),
          item.findElements('link').single.text,
          imgMatch.group(1),
          dateTime));
    });

    return Future.value(radioPrograms);
  }
}
