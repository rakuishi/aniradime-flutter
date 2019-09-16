class RadioStation {
  final String title;
  final String url;
  final String source;
  final String type;

  RadioStation(this.title, this.url, this.source, this.type);

  static List<RadioStation> createRadioStations() {
    List<RadioStation> tabItems = new List<RadioStation>();
    tabItems.add(RadioStation(
        '音泉', 'http://www.onsen.ag/', 'http://www.onsen.ag/', 'onsen'));
    tabItems.add(RadioStation(
        'シーサイドチャンネル',
        'http://ch.nicovideo.jp/seaside-channel',
        'http://ch.nicovideo.jp/seaside-channel/video?rss=2.0',
        'chnicovideo'));
    return tabItems;
  }
}
