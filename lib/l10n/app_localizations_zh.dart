// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_title => '学习追踪器';

  @override
  String get nav_study => '学习成果';

  @override
  String get nav_homework => '作业练习';

  @override
  String get tab_tracking => '记录打卡';

  @override
  String get tab_heatmap => '年度热力图';

  @override
  String get your_degrees => '你的学习目标 / 证书';

  @override
  String get new_degree_tooltip => '添加新目标';

  @override
  String get no_degrees_yet => '尚未添加任何学习目标。';

  @override
  String get final_exam_prefix => '毕业统考';

  @override
  String get intermediate_exam_prefix => '阶段考试 / 期中';

  @override
  String get netto_time_title => '关于“纯有效学习时间”';

  @override
  String get netto_warning => '在图书馆坐满 3 小时并不等于学了 3 小时，如果中途喝咖啡、刷手机，真实投入少之又少。';

  @override
  String get stopwatch_method_title => '秒表追踪法：';

  @override
  String get stopwatch_method_body =>
      '• 使用智能手表或机械手表的秒表功能。\n• 只有进入专注阅读与思考状态时才开启计时。\n• 一旦分心、停下或休息，立即暂停。\n• 每天只如实录入秒表计下的纯专注时间。';

  @override
  String get understood => '我知道了';

  @override
  String get netto_philosophy_tooltip => '纯学习时间理念';

  @override
  String get onboarding_title => '衡量你的真实纯专注时间';

  @override
  String get onboarding_warning_title => '杜绝虚假自律！';

  @override
  String get onboarding_warning_body =>
      '人类对时间的感觉极易出现偏差：在图书馆泡了整整 3 个小时，但中途抽烟、闲聊、刷手机，真实有效的时间可能只有 45 分钟。用 45 分钟的有效时间，根本无法消化 3 小时的专业内容。';

  @override
  String get onboarding_tip_title => '秒表 / 智能手表记录法则：';

  @override
  String get onboarding_tip_body =>
      '• 最好使用手表的计时功能。\n• 开始：当视线聚焦在讲义和习题上时再按开始。\n• 暂停：思维走神或停下来看窗外时立即暂停！\n• 录入：晚上仅记录秒表上的累积有效时长，对自己百分之百诚实。';

  @override
  String get first_degree_button => '创建第一个学习目标';

  @override
  String get week_tracked => '本周已记录';

  @override
  String get total_time => '累计总时间：';

  @override
  String get today_tracked => '今日记录：';

  @override
  String get hours_label => '小时';

  @override
  String get minutes_label => '分钟';

  @override
  String get hours_unit => '小时';

  @override
  String get minutes_unit => '分';

  @override
  String get add_time_button => '添加时间';

  @override
  String get history_title => '学习历程记录';

  @override
  String history_weeks(int count) {
    return '$count 周';
  }

  @override
  String countdown_text(int weeks, int days, String target) {
    return '距离 $target 还有 $weeks 周（$days 天）！';
  }

  @override
  String get heatmap_title => '365天全景热力图';

  @override
  String heatmap_days_ratio(int active) {
    return '$active / 365 天';
  }

  @override
  String get heatmap_subtitle => '满 20 分钟即亮起。投入越深，方块颜色越鲜艳。';

  @override
  String get heatmap_legend_min => '< 20分';

  @override
  String get heatmap_legend_max => '≥ 3小时';

  @override
  String get edit_today_title => '修改今日总时长';

  @override
  String get edit_today_desc => '请输入今日实际应当生效的精确总时间。';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get create_degree_title => '创建新目标';

  @override
  String get edit_degree_title => '编辑学习目标';

  @override
  String get degree_input_label => '专业认证 / 进修项目';

  @override
  String get degree_input_hint => '例如：IHK Controller, 商务汉语';

  @override
  String get exam_final_label => '最终考试日期';

  @override
  String get intermediate_exam_switch => '是否有阶段考试 / 模块考';

  @override
  String get intermediate_exam_label => '阶段考试日期';

  @override
  String get not_set => '未设定';
}
