import 'package:chedmed/utils/language_helper.dart';
import 'package:intl/intl.dart';

extension TimeFormatting on String {
  DateTime toDateTime() {
    return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(this).toLocal();
  }
}

extension TimeParser on DateTime {
  String toUtcDateTimeString() {
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return formatter.format(this) + "Z";
  }
}

extension TimePassed on DateTime {
  String toDate() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(this);
  }

  String toDateNoYear() {
    final DateFormat formatter = DateFormat('dd-MM');
    return formatter.format(this);
  }

  String toTime() {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(this);
  }

  String toDateTimeString() {
    final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    return formatter.format(this) + "Z";
  }

  String timePassedString() {
    var now = DateTime.now();
    var difference = now.difference(this);
    if (difference.inMinutes <= 1) return getTranslation.one_minute_ago;

    if (difference.inMinutes == 2) return getTranslation.two_minutes_ago;

    if (difference.inMinutes < 60)
      return getTranslation.minutes_ago(difference.inMinutes.toString());

    if (difference.inHours == 1) return getTranslation.one_hour_ago;

    if (difference.inHours == 2) return getTranslation.two_hours_ago;

    if (difference.inHours < 24)
      return getTranslation.hours_ago(difference.inHours.toString());

    if (difference.inDays == 1) return getTranslation.one_day_ago;

    if (difference.inDays == 2) return getTranslation.two_days_ago;
    if (difference.inDays < 7)
      return getTranslation.days_ago(difference.inDays.toString());

    return this.toDate();
  }

  String messageTimeString() {
    var now = DateTime.now();
    var difference = now.difference(this);

    // if (difference.inHours < 24 && this.day != now.day)
    //   return "Hier, " + toTime();
    if (difference.inHours < 24) return toTime();

    if (difference.inDays == 1) return "Hier";
    if (difference.inDays < 365) return toDateNoYear();
    return toDate();
  }
}

extension DurationExtension on Duration {
  /// Converts duration to MM:SS format
  String toMMSS() => toString().split('.').first.padLeft(8, "0").substring(3);
}
