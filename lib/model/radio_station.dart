class RadioStation {
  final String title;
  final String url;
  final String source;
  final String type;

  RadioStation(this.title, this.url, this.source, this.type);

  static List<RadioStation> createRadioStations() {
    List<RadioStation> stations = new List<RadioStation>();
    stations.add(RadioStation(
        '音泉', 'http://www.onsen.ag/', 'http://www.onsen.ag/', 'onsen'));
    stations.add(RadioStation(
        'シーサイドチャンネル',
        'http://ch.nicovideo.jp/seaside-channel',
        'http://ch.nicovideo.jp/seaside-channel/video?rss=2.0',
        'chnicovideo'));
    stations.add(RadioStation('セカンドショット', 'http://ch.nicovideo.jp/secondshot',
        'http://ch.nicovideo.jp/secondshot/video?rss=2.0', 'chnicovideo'));
    stations.add(RadioStation('超！アニメディア', 'http://ch.nicovideo.jp/animedia',
        'http://ch.nicovideo.jp/animedia/video?rss=2.0', 'chnicovideo'));
    stations.add(RadioStation('響', 'https://hibiki-radio.jp',
        'https://vcms-api.hibiki-radio.jp/api/v1//programs', 'hibiki'));
    return stations;
  }
}
