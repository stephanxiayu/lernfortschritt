import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/study_goal.dart';
import '../providers/tracker_provider.dart';

class AddEditGoalDialog extends StatefulWidget {
  final StudyGoal? goalToEdit;

  const AddEditGoalDialog({super.key, this.goalToEdit});

  @override
  State<AddEditGoalDialog> createState() => _AddEditGoalDialogState();
}

class _AddEditGoalDialogState extends State<AddEditGoalDialog> {
  final _titleController = TextEditingController();
  DateTime _finalExamDate = DateTime.now().add(const Duration(days: 180));
  DateTime? _intermediateExamDate;
  bool _hasIntermediateExam = false;

  final Color cardColor = const Color(0xFF161B22);
  final Color accentColor = const Color(0xFF2EA043);
  final Color secondaryTextColor = const Color(0xFF8B949E);

  @override
  void initState() {
    super.initState();
    if (widget.goalToEdit != null) {
      _titleController.text = widget.goalToEdit!.title;
      _finalExamDate = widget.goalToEdit!.finalExamDate;
      _intermediateExamDate = widget.goalToEdit!.intermediateExamDate;
      _hasIntermediateExam = _intermediateExamDate != null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFinal) async {
    final initial = isFinal ? _finalExamDate : (_intermediateExamDate ?? DateTime.now().add(const Duration(days: 90)));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) => Theme(data: ThemeData.dark(), child: child!),
    );

    if (picked != null) {
      setState(() {
        if (isFinal) {
          _finalExamDate = picked;
        } else {
          _intermediateExamDate = picked;
        }
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final provider = Provider.of<TrackerProvider>(context, listen: false);

    if (widget.goalToEdit == null) {
      provider.addGoal(
        title,
        _finalExamDate,
        _hasIntermediateExam ? _intermediateExamDate : null,
      );
    } else {
      final updated = StudyGoal(
        id: widget.goalToEdit!.id,
        title: title,
        finalExamDate: _finalExamDate,
        intermediateExamDate: _hasIntermediateExam ? _intermediateExamDate : null,
        createdAt: widget.goalToEdit!.createdAt,
      );
      provider.updateGoal(updated);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.goalToEdit == null ? 'Neuen Abschluss anlegen' : 'Abschluss bearbeiten',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Abschluss / Weiterbildung',
                hintText: 'z.B. IHK Controller, IHK Betriebswirt',
              ),
            ),
            const SizedBox(height: 16),
            // Endprüfung Datum
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Endprüfung / Hauptprüfung', style: TextStyle(color: Colors.white, fontSize: 14)),
              subtitle: Text(dateFormat.format(_finalExamDate), style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month, color: Colors.white70),
                onPressed: () => _selectDate(context, true),
              ),
            ),
            const Divider(color: Colors.white12),
            // Schalter für Zwischenprüfung
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: accentColor,
              title: const Text('Hat Zwischenprüfung / WBQ', style: TextStyle(color: Colors.white, fontSize: 14)),
              value: _hasIntermediateExam,
              onChanged: (val) {
                setState(() {
                  _hasIntermediateExam = val;
                  if (val && _intermediateExamDate == null) {
                    _intermediateExamDate = DateTime.now().add(const Duration(days: 90));
                  }
                });
              },
            ),
            if (_hasIntermediateExam) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Datum Zwischenprüfung', style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: Text(
                  _intermediateExamDate != null ? dateFormat.format(_intermediateExamDate!) : 'Nicht festgelegt',
                  style: const TextStyle(color: Color(0xFF58A6FF), fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.white70),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Speichern', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}