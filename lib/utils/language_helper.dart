import 'package:chedmed/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool isDirectionRTL(BuildContext context) {
  return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}

Locale currentLocale(BuildContext context) {
  return Localizations.localeOf(context);
}

AppLocalizations get getTranslation => AppLocalizations.of(requireContext())!;
