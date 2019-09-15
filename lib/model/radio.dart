class Radio {
  String title;
  String description;
  String url;
  String imageUrl;
  DateTime dateTime;

  Radio(String title, String description, String url, String imageUrl,
      DateTime dateTime) {
    this.title = title;
    this.description = description;
    this.url = url;
    this.imageUrl = imageUrl;
    this.dateTime = dateTime;
  }

  @override
  String toString() =>
      "Radio($title, $description, $url, $imageUrl, $dateTime)";
}
