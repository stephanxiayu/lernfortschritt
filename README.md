# 🎓 IHK Lern-Tracker (StudyTracker)

Ein fokussierter, modularer Flutter-Tracker im modernen Dark Mode zur Erfassung und Visualisierung der **echten Netto-Lernzeit** für anspruchsvolle Weiterbildungen und Abschlüsse (z. B. IHK Wirtschaftsfachwirt, Controller, Betriebswirt).

---

## 💡 Die Philosophie: Reine Netto-Lernzeit

> **Vermeide den Selbstbetrug!**  
> Unser Zeitgefühl ist trügerisch: Wer 3 Stunden in der Bibliothek verbringt, dabei aber Pausen macht, auf das Smartphone schaut oder sich unterhält, hat nicht 3 Stunden gelernt – sondern vielleicht nur 45 echte Minuten. In 45 Minuten Netto-Zeit lässt sich der Stoff von 3 Stunden jedoch nicht beherrschen.

### Die Stoppuhr- / Smartwatch-Methode
1. **Start:** Starte eine Stoppuhr (z. B. auf der Smartwatch oder Armbanduhr) genau dann, wenn du dich voll auf das Skript oder die Aufgabe konzentrierst.
2. **Pause:** Qualmt der Kopf oder schaust du auf das Handy? Stoppuhr sofort anhalten.
3. **Erfassen:** Am Ende des Tages wird ausschließlich die ungeschönte, kumulierte Netto-Zeit eingetragen.

---

## ✨ Features

- **Multi-Abschluss-Verwaltung:** Dynamisches Anlegen und Verwalten mehrerer Abschlüsse (z. B. IHK Wirtschaftsfachwirt, IHK Controller) mit getrenntem Tracking.
- **Prüfungs-Countdowns:** Unterstützung von Haupt-/Endprüfungen sowie optionalen Zwischenprüfungen (z. B. WBQ / HQ) mit automatischer Countdown-Anpassung.
- **Getrennte Tracks:** Unterscheidung zwischen Selbststudium (`Lernerfolg`) und `Hausaufgaben` / Einsendeaufgaben pro Abschluss.
- **365-Tage Jahres-Heatmap (GitHub-Style):**
  - Feste 52-Wochen-Übersicht ($52 \times 7$ Tage) ohne horizontales Scrollen.
  - **5-Stufen-Farbintensität** zur Visualisierung des Fokus (Schwellenwert ab 20 Min. bis $\ge 3$ Std.).
- **Historie & Wochenanalysen:** Automatische Berechnung von Wochenstunden (Wochenstart Samstag), Gesamtlernzeit und historischen Wochenblöcken.
- **Offline-First & Datensicherheit:** Vollständig lokale relationale Speicherung via SQLite (`sqflite`) inklusive nahtloser, verlustfreier Migration aus Altbeständen (`SharedPreferences`).

---

## 🎨 Heatmap Farbabstufungen

| Lernzeit | Farbwert | Bedeutung |
| :--- | :--- | :--- |
| **0 – 19 min** | `#0D1117` | Noch kein Lernfokus / Ruhetag |
| **20 – 44 min** | `#D1FAE5` | Kurze Einheit / Einstieg |
| **45 – 89 min** | `#86EFAC` | Solide Lerneinheit |
| **90 – 134 min** | `#4ADE80` | Intensive Session ($\ge 1{,}5$ h) |
| **135 – 179 min** | `#22C55E` | Starke Lerneinheit ($\ge 2{,}25$ h) |
| **$\ge$ 180 min** | `#15803D` | Voller Fokustag ($\ge 3$ h) |

---

## 🏛 Architektur & Projektstruktur

Die App folgt einer klaren Schichtenarchitektur (Separation of Concerns) unter Verwendung des `Provider`-Patterns für reaktives State Management:

```text
lib/
├── db/
│   └── database_helper.dart      # SQLite-Setup, Tabellen-Erstellung & Migration aus SharedPreferences
├── models/
│   ├── study_goal.dart           # Datenmodell für Abschlüsse (Titel, Prüfungsdaten)
│   └── study_entry.dart          # Datenmodell für einzelne Tageseinträge (Minuten, Datum, Track)
├── providers/
│   └── tracker_provider.dart     # Business Logic & State Management (CRUD, Stats, Berechnungen)
├── screens/
│   ├── main_navigation_screen.dart # Haupt-Scaffold mit Bottom-Navigation & Abschluss-Selector
│   ├── sub_track_view.dart       # Tab-Controller für Erfassung & Heatmap
│   └── add_edit_goal_dialog.dart # Bottom-Sheet zum Anlegen & Bearbeiten von Zielen
└── main.dart                     # App-Einstiegspunkt, Theme & MultiProvider-Setup
