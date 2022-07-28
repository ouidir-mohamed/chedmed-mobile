import 'package:intl/intl.dart';

extension TimeFormatting on String {
  DateTime toDateTime() {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(this);
  }
}

extension TimePassed on DateTime {
  String toDate() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(this);
  }

  String toDateTimeString() {
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return formatter.format(this) + "Z";
  }

  String timePassedString() {
    var now = DateTime.now();
    var difference = now.difference(this);
    if (difference.inMinutes <= 1) {
      return "Il ya une minute";
    }
    if (difference.inMinutes < 60) {
      return "Il ya " + difference.inMinutes.toString() + " minutes";
    }

    if (difference.inHours == 1) {
      return "Il ya une heure";
    }
    if (difference.inHours < 24) {
      return "Il ya " + difference.inHours.toString() + " heures";
    }

    if (difference.inDays < 7) {
      return "Il ya " + difference.inDays.toString() + " jours";
    }
    return this.toDate();
  }
}
