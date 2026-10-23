// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app_title => 'Lern-Tracker';

  @override
  String get nav_study => 'Lernerfolg';

  @override
  String get nav_homework => 'Hausaufgaben';

  @override
  String get tab_tracking => 'Erfassung';

  @override
  String get tab_heatmap => 'Jahres-Heatmap';

  @override
  String get your_degrees => 'Deine Abschlüsse';

  @override
  String get new_degree_tooltip => 'Neuen Abschluss hinzufügen';

  @override
  String get no_degrees_yet => 'Noch keine Abschlüsse angelegt.';

  @override
  String get final_exam_prefix => 'Endprüfung';

  @override
  String get intermediate_exam_prefix => 'Zwischenprüfung';

  @override
  String get netto_time_title => 'Die Netto-Lernzeit';

  @override
  String get netto_warning =>
      '3 Stunden physische Anwesenheit in der Bib sind keine 3 Stunden Lernen, wenn man Kaffeepausen macht oder das Handy checkt.';

  @override
  String get stopwatch_method_title => 'Die Stoppuhr-Methode:';

  @override
  String get stopwatch_method_body =>
      '• Nimm eine Smartwatch oder Armbanduhr mit Stoppuhr.\n• Starte die Uhr nur, wenn du aktiv denkst und liest.\n• Pausiere die Uhr bei jeder Unterbrechung sofort.\n• Trage abends nur die tatsächliche Netto-Zeit hier ein.';

  @override
  String get understood => 'Verstanden';

  @override
  String get netto_philosophy_tooltip => 'Das Prinzip der Netto-Lernzeit';

  @override
  String get onboarding_title => 'Miss deine echte Netto-Zeit';

  @override
  String get onboarding_warning_title => 'Vermeide den Selbstbetrug!';

  @override
  String get onboarding_warning_body =>
      'Unser Zeitgefühl ist extrem trügerisch: Wer 3 Stunden in der Bibliothek sitzt, aber nach 20 Minuten raucht, aufs Smartphone schaut oder quatscht, hat nicht 3 Stunden gelernt – sondern vielleicht nur 45 echte Minuten. In 45 Minuten Netto-Zeit kannst du den Stoff von 3 Stunden nicht beherrschen.';

  @override
  String get onboarding_tip_title => 'Die Smartwatch- / Stoppuhr-Methode:';

  @override
  String get onboarding_tip_body =>
      '• Nutze am besten eine Smartwatch oder Armbanduhr mit Stoppuhr.\n• Start: Drücke Start genau dann, wenn du dich voll auf das Skript konzentrierst.\n• Pause: Qualmt der Kopf oder schaust du aus dem Fenster? Stoppuhr sofort anhalten!\n• Erfassen: Trage nur die gestoppte Netto-Zeit hier ein. Sei 100% ehrlich zu dir selbst.';

  @override
  String get first_degree_button => 'Deinen ersten Abschluss anlegen';

  @override
  String get week_tracked => 'Diese Woche erfasst';

  @override
  String get total_time => 'Gesamte Zeit:';

  @override
  String get today_tracked => 'Heute erfasst:';

  @override
  String get hours_label => 'Stunden';

  @override
  String get minutes_label => 'Minuten';

  @override
  String get hours_unit => 'h';

  @override
  String get minutes_unit => 'm';

  @override
  String get add_time_button => 'Zeit hinzufügen';

  @override
  String get history_title => 'Lernfortschritt Historie';

  @override
  String history_weeks(int count) {
    return '$count Wochen';
  }

  @override
  String countdown_text(int weeks, int days, String target) {
    return 'Noch $weeks Wochen ($days Tage) bis zur $target!';
  }

  @override
  String get heatmap_title => '365 Tage Übersicht';

  @override
  String heatmap_days_ratio(int active) {
    return '$active / 365 Tage';
  }

  @override
  String get heatmap_subtitle =>
      'Aktiv ab 20 Min. Je länger du gelernt hast, desto kräftiger leuchtet das Feld.';

  @override
  String get heatmap_legend_min => '< 20m';

  @override
  String get heatmap_legend_max => '≥ 3h';

  @override
  String get edit_today_title => 'Korrektur für heute';

  @override
  String get edit_today_desc =>
      'Gib die exakte Zeit ein, die heute insgesamt gelten soll.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get create_degree_title => 'Neuen Abschluss anlegen';

  @override
  String get edit_degree_title => 'Abschluss bearbeiten';

  @override
  String get degree_input_label => 'Abschluss / Weiterbildung';

  @override
  String get degree_input_hint => 'z.B. IHK Controller, IHK Betriebswirt';

  @override
  String get exam_final_label => 'Endprüfung / Hauptprüfung';

  @override
  String get intermediate_exam_switch => 'Hat Zwischenprüfung / WBQ';

  @override
  String get intermediate_exam_label => 'Datum Zwischenprüfung';

  @override
  String get not_set => 'Nicht festgelegt';
}
