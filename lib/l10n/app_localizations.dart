import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @app_title.
  ///
  /// In de, this message translates to:
  /// **'Lern-Tracker'**
  String get app_title;

  /// No description provided for @nav_study.
  ///
  /// In de, this message translates to:
  /// **'Lernerfolg'**
  String get nav_study;

  /// No description provided for @nav_homework.
  ///
  /// In de, this message translates to:
  /// **'Hausaufgaben'**
  String get nav_homework;

  /// No description provided for @tab_tracking.
  ///
  /// In de, this message translates to:
  /// **'Erfassung'**
  String get tab_tracking;

  /// No description provided for @tab_heatmap.
  ///
  /// In de, this message translates to:
  /// **'Jahres-Heatmap'**
  String get tab_heatmap;

  /// No description provided for @your_degrees.
  ///
  /// In de, this message translates to:
  /// **'Deine Abschlüsse'**
  String get your_degrees;

  /// No description provided for @new_degree_tooltip.
  ///
  /// In de, this message translates to:
  /// **'Neuen Abschluss hinzufügen'**
  String get new_degree_tooltip;

  /// No description provided for @no_degrees_yet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Abschlüsse angelegt.'**
  String get no_degrees_yet;

  /// No description provided for @final_exam_prefix.
  ///
  /// In de, this message translates to:
  /// **'Endprüfung'**
  String get final_exam_prefix;

  /// No description provided for @intermediate_exam_prefix.
  ///
  /// In de, this message translates to:
  /// **'Zwischenprüfung'**
  String get intermediate_exam_prefix;

  /// No description provided for @netto_time_title.
  ///
  /// In de, this message translates to:
  /// **'Die Netto-Lernzeit'**
  String get netto_time_title;

  /// No description provided for @netto_warning.
  ///
  /// In de, this message translates to:
  /// **'3 Stunden physische Anwesenheit in der Bib sind keine 3 Stunden Lernen, wenn man Kaffeepausen macht oder das Handy checkt.'**
  String get netto_warning;

  /// No description provided for @stopwatch_method_title.
  ///
  /// In de, this message translates to:
  /// **'Die Stoppuhr-Methode:'**
  String get stopwatch_method_title;

  /// No description provided for @stopwatch_method_body.
  ///
  /// In de, this message translates to:
  /// **'• Nimm eine Smartwatch oder Armbanduhr mit Stoppuhr.\n• Starte die Uhr nur, wenn du aktiv denkst und liest.\n• Pausiere die Uhr bei jeder Unterbrechung sofort.\n• Trage abends nur die tatsächliche Netto-Zeit hier ein.'**
  String get stopwatch_method_body;

  /// No description provided for @understood.
  ///
  /// In de, this message translates to:
  /// **'Verstanden'**
  String get understood;

  /// No description provided for @netto_philosophy_tooltip.
  ///
  /// In de, this message translates to:
  /// **'Das Prinzip der Netto-Lernzeit'**
  String get netto_philosophy_tooltip;

  /// No description provided for @onboarding_title.
  ///
  /// In de, this message translates to:
  /// **'Miss deine echte Netto-Zeit'**
  String get onboarding_title;

  /// No description provided for @onboarding_warning_title.
  ///
  /// In de, this message translates to:
  /// **'Vermeide den Selbstbetrug!'**
  String get onboarding_warning_title;

  /// No description provided for @onboarding_warning_body.
  ///
  /// In de, this message translates to:
  /// **'Unser Zeitgefühl ist extrem trügerisch: Wer 3 Stunden in der Bibliothek sitzt, aber nach 20 Minuten raucht, aufs Smartphone schaut oder quatscht, hat nicht 3 Stunden gelernt – sondern vielleicht nur 45 echte Minuten. In 45 Minuten Netto-Zeit kannst du den Stoff von 3 Stunden nicht beherrschen.'**
  String get onboarding_warning_body;

  /// No description provided for @onboarding_tip_title.
  ///
  /// In de, this message translates to:
  /// **'Die Smartwatch- / Stoppuhr-Methode:'**
  String get onboarding_tip_title;

  /// No description provided for @onboarding_tip_body.
  ///
  /// In de, this message translates to:
  /// **'• Nutze am besten eine Smartwatch oder Armbanduhr mit Stoppuhr.\n• Start: Drücke Start genau dann, wenn du dich voll auf das Skript konzentrierst.\n• Pause: Qualmt der Kopf oder schaust du aus dem Fenster? Stoppuhr sofort anhalten!\n• Erfassen: Trage nur die gestoppte Netto-Zeit hier ein. Sei 100% ehrlich zu dir selbst.'**
  String get onboarding_tip_body;

  /// No description provided for @first_degree_button.
  ///
  /// In de, this message translates to:
  /// **'Deinen ersten Abschluss anlegen'**
  String get first_degree_button;

  /// No description provided for @week_tracked.
  ///
  /// In de, this message translates to:
  /// **'Diese Woche erfasst'**
  String get week_tracked;

  /// No description provided for @total_time.
  ///
  /// In de, this message translates to:
  /// **'Gesamte Zeit:'**
  String get total_time;

  /// No description provided for @today_tracked.
  ///
  /// In de, this message translates to:
  /// **'Heute erfasst:'**
  String get today_tracked;

  /// No description provided for @hours_label.
  ///
  /// In de, this message translates to:
  /// **'Stunden'**
  String get hours_label;

  /// No description provided for @minutes_label.
  ///
  /// In de, this message translates to:
  /// **'Minuten'**
  String get minutes_label;

  /// No description provided for @hours_unit.
  ///
  /// In de, this message translates to:
  /// **'h'**
  String get hours_unit;

  /// No description provided for @minutes_unit.
  ///
  /// In de, this message translates to:
  /// **'m'**
  String get minutes_unit;

  /// No description provided for @add_time_button.
  ///
  /// In de, this message translates to:
  /// **'Zeit hinzufügen'**
  String get add_time_button;

  /// No description provided for @history_title.
  ///
  /// In de, this message translates to:
  /// **'Lernfortschritt Historie'**
  String get history_title;

  /// No description provided for @history_weeks.
  ///
  /// In de, this message translates to:
  /// **'{count} Wochen'**
  String history_weeks(int count);

  /// No description provided for @countdown_text.
  ///
  /// In de, this message translates to:
  /// **'Noch {weeks} Wochen ({days} Tage) bis zur {target}!'**
  String countdown_text(int weeks, int days, String target);

  /// No description provided for @heatmap_title.
  ///
  /// In de, this message translates to:
  /// **'365 Tage Übersicht'**
  String get heatmap_title;

  /// No description provided for @heatmap_days_ratio.
  ///
  /// In de, this message translates to:
  /// **'{active} / 365 Tage'**
  String heatmap_days_ratio(int active);

  /// No description provided for @heatmap_subtitle.
  ///
  /// In de, this message translates to:
  /// **'Aktiv ab 20 Min. Je länger du gelernt hast, desto kräftiger leuchtet das Feld.'**
  String get heatmap_subtitle;

  /// No description provided for @heatmap_legend_min.
  ///
  /// In de, this message translates to:
  /// **'< 20m'**
  String get heatmap_legend_min;

  /// No description provided for @heatmap_legend_max.
  ///
  /// In de, this message translates to:
  /// **'≥ 3h'**
  String get heatmap_legend_max;

  /// No description provided for @edit_today_title.
  ///
  /// In de, this message translates to:
  /// **'Korrektur für heute'**
  String get edit_today_title;

  /// No description provided for @edit_today_desc.
  ///
  /// In de, this message translates to:
  /// **'Gib die exakte Zeit ein, die heute insgesamt gelten soll.'**
  String get edit_today_desc;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @create_degree_title.
  ///
  /// In de, this message translates to:
  /// **'Neuen Abschluss anlegen'**
  String get create_degree_title;

  /// No description provided for @edit_degree_title.
  ///
  /// In de, this message translates to:
  /// **'Abschluss bearbeiten'**
  String get edit_degree_title;

  /// No description provided for @degree_input_label.
  ///
  /// In de, this message translates to:
  /// **'Abschluss / Weiterbildung'**
  String get degree_input_label;

  /// No description provided for @degree_input_hint.
  ///
  /// In de, this message translates to:
  /// **'z.B. IHK Controller, IHK Betriebswirt'**
  String get degree_input_hint;

  /// No description provided for @exam_final_label.
  ///
  /// In de, this message translates to:
  /// **'Endprüfung / Hauptprüfung'**
  String get exam_final_label;

  /// No description provided for @intermediate_exam_switch.
  ///
  /// In de, this message translates to:
  /// **'Hat Zwischenprüfung / WBQ'**
  String get intermediate_exam_switch;

  /// No description provided for @intermediate_exam_label.
  ///
  /// In de, this message translates to:
  /// **'Datum Zwischenprüfung'**
  String get intermediate_exam_label;

  /// No description provided for @not_set.
  ///
  /// In de, this message translates to:
  /// **'Nicht festgelegt'**
  String get not_set;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
