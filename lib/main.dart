import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lernfortschritt/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'models/study_goal.dart';
import 'providers/tracker_provider.dart';
import 'screens/add_edit_goal_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final trackerProvider = TrackerProvider();
  await trackerProvider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: trackerProvider,
      child: const StudyTrackerApp(),
    ),
  );
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.app_title,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Deutsch -> de, Chinesisch -> zh, alles andere Fallback auf en
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          if (deviceLocale.languageCode == 'de') return const Locale('de');
          if (deviceLocale.languageCode == 'zh') return const Locale('zh');
        }
        return const Locale('en');
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardTheme: const CardThemeData(
          color: Color(0xFF161B22),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF161B22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF2EA043), width: 1.5),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentNavIndex = 0; // 0 = Lernerfolg, 1 = Hausaufgaben

  final Color cardColor = const Color(0xFF161B22);
  final Color accentColor = const Color(0xFF2EA043);
  final Color successColor = const Color(0xFF58A6FF);
  final Color secondaryTextColor = const Color(0xFF8B949E);

  void _openGoalSelector(BuildContext context, TrackerProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocaleStr = Localizations.localeOf(context).toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFF30363D),
                      borderRadius: BorderRadius.circular(2)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.your_degrees,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: accentColor, size: 28),
                      tooltip: l10n.new_degree_tooltip,
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openAddEditGoalDialog(context);
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white12),
                if (provider.goals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(l10n.no_degrees_yet,
                        style: TextStyle(color: secondaryTextColor)),
                  )
                else
                  ...provider.goals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    final isSelected = index == provider.selectedGoalIndex;

                    return Material(
                      color: isSelected
                          ? accentColor.withValues(alpha: 0.15)
                          : const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected
                                  ? accentColor.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: ListTile(
                          title: Text(goal.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          subtitle: Text(
                            "${l10n.final_exam_prefix}: ${DateFormat.yMd(currentLocaleStr).format(goal.finalExamDate)}",
                            style: TextStyle(
                                color: secondaryTextColor, fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: Colors.grey, size: 20),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _openAddEditGoalDialog(context, goal: goal);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent, size: 20),
                                onPressed: () =>
                                    provider.deleteGoal(goal.id!),
                              ),
                            ],
                          ),
                          onTap: () {
                            provider.selectGoal(index);
                            Navigator.pop(ctx);
                          },
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddEditGoalDialog(BuildContext context, {StudyGoal? goal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditGoalDialog(goalToEdit: goal),
    );
  }

  void _showNettoPhilosophyDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        title: Row(
          children: [
            Icon(Icons.timer_outlined, color: accentColor, size: 24),
            const SizedBox(width: 10),
            Text(l10n.netto_time_title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1917),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.amber.shade700.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.amber.shade400, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.netto_warning,
                        style: TextStyle(
                            color: Colors.amber.shade200,
                            fontSize: 12,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(l10n.stopwatch_method_title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                l10n.stopwatch_method_body,
                style: TextStyle(
                    color: secondaryTextColor, fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.understood,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final currentGoal = provider.currentGoal;
    final track = _currentNavIndex == 0 ? 'study' : 'homework';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _openGoalSelector(context, provider),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                currentGoal?.title ?? l10n.no_degrees_yet,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 19,
                                  letterSpacing: -0.4,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                color: successColor, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline_rounded,
                        color: secondaryTextColor, size: 22),
                    tooltip: l10n.netto_philosophy_tooltip,
                    onPressed: () => _showNettoPhilosophyDialog(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: accentColor, size: 26),
                    tooltip: l10n.new_degree_tooltip,
                    onPressed: () => _openAddEditGoalDialog(context),
                  ),
                ],
              ),
            ),

            // --- INHALT ODER EMPTY-STATE ---
            Expanded(
              child: currentGoal == null
                  ? _buildEmptyOnboardingState(context)
                  : SubTrackView(
                      key: ValueKey("${currentGoal.id}_$track"),
                      goal: currentGoal,
                      track: track,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF020617),
        indicatorColor: accentColor.withValues(alpha: 0.2),
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.school_outlined, color: Colors.grey),
            selectedIcon: const Icon(Icons.school, color: Color(0xFF2EA043)),
            label: l10n.nav_study,
          ),
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined, color: Colors.grey),
            selectedIcon: const Icon(Icons.assignment, color: Color(0xFF2EA043)),
            label: l10n.nav_homework,
          ),
        ],
      ),
    );
  }

  // --- AUSFÜHRLICHER ONBOARDING-SCREEN MIT WARNDREIECK & SMARTWATCH-TIPP ---
  Widget _buildEmptyOnboardingState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.timer_outlined, size: 32, color: accentColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.onboarding_title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 1. GELBE WARN-BOX: Selbstbetrug & Bib-Falle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1917),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.amber.shade700.withValues(alpha: 0.4), width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.amber.shade400, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboarding_warning_title,
                          style: TextStyle(
                            color: Colors.amber.shade300,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.onboarding_warning_body,
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. TIPP-BOX: Smartwatch / Stoppuhr-Methode
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: successColor.withValues(alpha: 0.25), width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.watch_outlined, color: successColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.onboarding_tip_title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.onboarding_tip_body,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_circle_outline,
                    color: Colors.white, size: 20),
                label: Text(
                  l10n.first_degree_button,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                onPressed: () => _openAddEditGoalDialog(context),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class SubTrackView extends StatefulWidget {
  final StudyGoal goal;
  final String track;

  const SubTrackView({super.key, required this.goal, required this.track});

  @override
  State<SubTrackView> createState() => _SubTrackViewState();
}

class _SubTrackViewState extends State<SubTrackView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  // Eigene FocusNodes gegen Fokus-Blockaden
  final FocusNode _hoursFocusNode = FocusNode();
  final FocusNode _minutesFocusNode = FocusNode();

  Future<Map<String, dynamic>>? _statsFuture;

  final Color backgroundColor = const Color(0xFF0D1117);
  final Color cardColor = const Color(0xFF161B22);
  final Color accentColor = const Color(0xFF2EA043);
  final Color successColor = const Color(0xFF58A6FF);
  final Color secondaryTextColor = const Color(0xFF8B949E);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadStats();
  }

  @override
  void didUpdateWidget(covariant SubTrackView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.id != widget.goal.id || oldWidget.track != widget.track) {
      _reloadStats();
    }
  }

  void _reloadStats() {
    final provider = Provider.of<TrackerProvider>(context, listen: false);
    setState(() {
      _statsFuture = provider.getTrackStats(widget.track);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _hoursFocusNode.dispose();
    _minutesFocusNode.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 6),
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: successColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: successColor.withValues(alpha: 0.5), width: 1),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: secondaryTextColor,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_note_rounded, size: 17),
                    const SizedBox(width: 6),
                    Text(l10n.tab_tracking),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.grid_view_rounded, size: 16),
                    const SizedBox(width: 6),
                    Text(l10n.tab_heatmap),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _statsFuture,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(color: successColor));
              }

              final stats = snapshot.data ?? {};
              final int todayMinutes = stats['todayMinutes'] ?? 0;
              final int weeklyMinutes = stats['weeklyMinutes'] ?? 0;
              final int totalMinutes = stats['totalMinutes'] ?? 0;
              final List<Map<String, dynamic>> pastWeeks =
                  stats['pastWeeks'] ?? [];
              final Map<String, int> dailyMap = stats['dailyMap'] ?? {};

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildInputTab(todayMinutes, weeklyMinutes, totalMinutes,
                      pastWeeks, provider),
                  _buildHeatmapTab(dailyMap),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputTab(int todayMinutes, int weeklyMinutes, int totalMinutes,
      List<Map<String, dynamic>> pastWeeks, TrackerProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();

    DateTime targetDate = widget.goal.finalExamDate;
    String targetLabel = l10n.final_exam_prefix;

    if (widget.goal.intermediateExamDate != null &&
        widget.goal.intermediateExamDate!.isAfter(today)) {
      targetDate = widget.goal.intermediateExamDate!;
      targetLabel = l10n.intermediate_exam_prefix;
    }

    final daysLeft = max(0, targetDate.difference(today).inDays);
    final weeksLeft = (daysLeft / 7).floor();

    final weeklyHours = weeklyMinutes ~/ 60;
    final weeklyMins = weeklyMinutes % 60;
    final totalHours = totalMinutes ~/ 60;
    final totalMins = totalMinutes % 60;
    final todayHours = todayMinutes ~/ 60;
    final todayMins = todayMinutes % 60;

    final hUnit = l10n.hours_unit;
    final mUnit = l10n.minutes_unit;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Column(
                children: [
                  Text(l10n.week_tracked,
                      style: TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('$weeklyHours$hUnit $weeklyMins$mUnit',
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: accentColor)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.all_inclusive, color: successColor, size: 20),
                      const SizedBox(width: 10),
                      Text(l10n.total_time,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70)),
                    ],
                  ),
                  Text('$totalHours$hUnit $totalMins$mUnit',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                children: [
                  Icon(Icons.flag_rounded, color: accentColor, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.countdown_text(weeksLeft, daysLeft, targetLabel),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.today_tracked,
                        style: TextStyle(
                            fontSize: 12, color: secondaryTextColor)),
                    Text('$todayHours$hUnit $todayMins$mUnit',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                IconButton(
                  onPressed: () => _showEditDialog(todayMinutes, provider),
                  icon: const Icon(Icons.edit_outlined,
                      color: Colors.grey, size: 20),
                )
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _hoursController,
                    focusNode: _hoursFocusNode,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        labelText: l10n.hours_label,
                        suffixText: hUnit,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _minutesController,
                    focusNode: _minutesFocusNode,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                        labelText: l10n.minutes_label,
                        suffixText: mUnit,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () async {
                final h = int.tryParse(_hoursController.text) ?? 0;
                final m = int.tryParse(_minutesController.text) ?? 0;
                if (h == 0 && m == 0) return;

                _hoursController.clear();
                _minutesController.clear();

                _hoursFocusNode.unfocus();
                _minutesFocusNode.unfocus();

                await provider.addMinutes(widget.track, (h * 60) + m);
                _reloadStats();
              },
              icon: const Icon(Icons.add, size: 20),
              label: Text(l10n.add_time_button,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (pastWeeks.isNotEmpty) ...[
            Card(
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.history_title,
                            style: TextStyle(
                                fontSize: 13,
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w600)),
                        Text(l10n.history_weeks(pastWeeks.length),
                            style: TextStyle(
                                fontSize: 12, color: secondaryTextColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...pastWeeks.map((weekData) {
                      final mins = weekData['minutes'] as int;
                      final h = mins ~/ 60;
                      final m = mins % 60;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(weekData['label'] as String,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                            Text('$h$hUnit $m$mUnit',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- DIE 5-STUFIGE JAHRES-HEATMAP (AB 20 MINUTEN AKTIV) ---
  Widget _buildHeatmapTab(Map<String, int> dailyMap) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const int totalWeeks = 52;

    final startDate =
        today.subtract(const Duration(days: (totalWeeks * 7) - 1));

    int activeDaysCount = 0;
    for (int d = 0; d < 365; d++) {
      final date = today.subtract(Duration(days: d));
      final dateKey = _formatDate(date);
      if ((dailyMap[dateKey] ?? 0) >= 20) {
        activeDaysCount++;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.heatmap_title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: accentColor.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      l10n.heatmap_days_ratio(activeDaysCount),
                      style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.heatmap_subtitle,
                style: TextStyle(fontSize: 11, color: secondaryTextColor),
              ),
              const SizedBox(height: 12),

              Row(
                children: List.generate(totalWeeks, (colIndex) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(7, (rowIndex) {
                          final dayOffset = (colIndex * 7) + rowIndex;
                          final currentDay =
                              startDate.add(Duration(days: dayOffset));

                          if (currentDay.isAfter(today)) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.25),
                              child: AspectRatio(
                                  aspectRatio: 1, child: SizedBox.shrink()),
                            );
                          }

                          final dateKey = _formatDate(currentDay);
                          final minutes = dailyMap[dateKey] ?? 0;

                          Color boxColor = backgroundColor;
                          if (minutes >= 20) {
                            if (minutes >= 180) {
                              boxColor = const Color(0xFF15803D); // >= 3h
                            } else if (minutes >= 135) {
                              boxColor = const Color(0xFF22C55E); // >= 2h 15m
                            } else if (minutes >= 90) {
                              boxColor = const Color(0xFF4ADE80); // >= 1h 30m
                            } else if (minutes >= 45) {
                              boxColor = const Color(0xFF86EFAC); // >= 45m
                            } else {
                              boxColor = const Color(0xFFD1FAE5); // 20 - 44m
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.25),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor,
                                  borderRadius: BorderRadius.circular(1.0),
                                  border: Border.all(
                                    color: minutes >= 20
                                        ? boxColor
                                        : Colors.white.withValues(alpha: 0.04),
                                    width: 0.4,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(l10n.heatmap_legend_min,
                      style:
                          TextStyle(color: secondaryTextColor, fontSize: 9)),
                  const SizedBox(width: 3),
                  _buildLegendBox(backgroundColor),
                  const SizedBox(width: 4),
                  _buildLegendBox(const Color(0xFFD1FAE5)),
                  const SizedBox(width: 2),
                  _buildLegendBox(const Color(0xFF86EFAC)),
                  const SizedBox(width: 2),
                  _buildLegendBox(const Color(0xFF4ADE80)),
                  const SizedBox(width: 2),
                  _buildLegendBox(const Color(0xFF22C55E)),
                  const SizedBox(width: 2),
                  _buildLegendBox(const Color(0xFF15803D)),
                  const SizedBox(width: 3),
                  Text(l10n.heatmap_legend_max,
                      style:
                          TextStyle(color: secondaryTextColor, fontSize: 9)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }

  Future<void> _showEditDialog(
      int currentMinutes, TrackerProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final hController =
        TextEditingController(text: (currentMinutes ~/ 60).toString());
    final mController =
        TextEditingController(text: (currentMinutes % 60).toString());

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        title: Text(l10n.edit_today_title,
            style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.edit_today_desc,
                style: TextStyle(color: secondaryTextColor, fontSize: 13)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: hController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: l10n.hours_label,
                            suffixText: l10n.hours_unit))),
                const SizedBox(width: 16),
                Expanded(
                    child: TextField(
                        controller: mController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: l10n.minutes_label,
                            suffixText: l10n.minutes_unit))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel,
                  style: TextStyle(color: secondaryTextColor))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: accentColor, foregroundColor: Colors.white),
            onPressed: () async {
              final h = int.tryParse(hController.text) ?? 0;
              final m = int.tryParse(mController.text) ?? 0;
              Navigator.pop(ctx);
              await provider.setTodayMinutes(widget.track, (h * 60) + m);
              _reloadStats();
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}