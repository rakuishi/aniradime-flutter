import 'package:intl/intl.dart';

class RadioProgram {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime dateTime;

  RadioProgram(this.title, this.description, this.url, this.imageUrl,
      this.dateTime);

  String formattedDateTime() => DateFormat('yyyy/MM/dd').format(dateTime);

  @override
  String toString() =>
      "Radio($title, $description, $url, $imageUrl, $dateTime)";
}
