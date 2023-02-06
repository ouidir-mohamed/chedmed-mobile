import 'package:flutter_vibrate/flutter_vibrate.dart';

vibrateThePhone() async {
  if (await Vibrate.canVibrate) {
    Vibrate.feedback(FeedbackType.selection);
  }
}
