// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Study Tracker';

  @override
  String get nav_study => 'Study Progress';

  @override
  String get nav_homework => 'Assignments';

  @override
  String get tab_tracking => 'Log Time';

  @override
  String get tab_heatmap => 'Annual Heatmap';

  @override
  String get your_degrees => 'Your Goals & Qualifications';

  @override
  String get new_degree_tooltip => 'Add new goal';

  @override
  String get no_degrees_yet => 'No qualifications added yet.';

  @override
  String get final_exam_prefix => 'Final Exam';

  @override
  String get intermediate_exam_prefix => 'Intermediate Exam';

  @override
  String get netto_time_title => 'Net Focus Time';

  @override
  String get netto_warning =>
      'Spending 3 hours in the library is not 3 hours of studying if breaks, coffees, and phone checks eat away the time.';

  @override
  String get stopwatch_method_title => 'The Stopwatch Method:';

  @override
  String get stopwatch_method_body =>
      '• Use a smartwatch or wristwatch with a stopwatch.\n• Only start the clock when you are actively reading and solving problems.\n• Stop the timer immediately at any distraction or break.\n• Log strictly the recorded net time at the end of the day.';

  @override
  String get understood => 'Understood';

  @override
  String get netto_philosophy_tooltip => 'The Net Time Principle';

  @override
  String get onboarding_title => 'Track Your True Net Study Time';

  @override
  String get onboarding_warning_title => 'Avoid Self-Deception!';

  @override
  String get onboarding_warning_body =>
      'Our perception of time is deceptive: sitting 3 hours in the library, interrupted by phone scrolling or chat breaks, might only be 45 actual minutes. 45 minutes of net focus cannot master 3 hours worth of complex study material.';

  @override
  String get onboarding_tip_title => 'The Smartwatch / Stopwatch Routine:';

  @override
  String get onboarding_tip_body =>
      '• Use a watch with a stopwatch function.\n• Start: Hit start precisely when deep work begins.\n• Pause: Whenever you lose focus or step away, pause immediately.\n• Log: Enter only the stopwatch-verified net time. Stay 100% truthful.';

  @override
  String get first_degree_button => 'Create Your First Goal';

  @override
  String get week_tracked => 'Logged This Week';

  @override
  String get total_time => 'Total Time:';

  @override
  String get today_tracked => 'Logged Today:';

  @override
  String get hours_label => 'Hours';

  @override
  String get minutes_label => 'Minutes';

  @override
  String get hours_unit => 'h';

  @override
  String get minutes_unit => 'm';

  @override
  String get add_time_button => 'Add Time';

  @override
  String get history_title => 'Study History';

  @override
  String history_weeks(int count) {
    return '$count weeks';
  }

  @override
  String countdown_text(int weeks, int days, String target) {
    return '$weeks weeks ($days days) remaining until $target!';
  }

  @override
  String get heatmap_title => '365-Day Overview';

  @override
  String heatmap_days_ratio(int active) {
    return '$active / 365 days';
  }

  @override
  String get heatmap_subtitle =>
      'Active from 20 min. The more you study, the richer the color.';

  @override
  String get heatmap_legend_min => '< 20m';

  @override
  String get heatmap_legend_max => '≥ 3h';

  @override
  String get edit_today_title => 'Edit Today\'s Time';

  @override
  String get edit_today_desc => 'Enter the exact total duration for today.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get create_degree_title => 'New Goal';

  @override
  String get edit_degree_title => 'Edit Goal';

  @override
  String get degree_input_label => 'Degree / Qualification';

  @override
  String get degree_input_hint => 'e.g. Business Specialist, Controller';

  @override
  String get exam_final_label => 'Final Exam Date';

  @override
  String get intermediate_exam_switch => 'Has Intermediate Exam';

  @override
  String get intermediate_exam_label => 'Intermediate Exam Date';

  @override
  String get not_set => 'Not set';
}
