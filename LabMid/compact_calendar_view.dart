import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// FIX 1: TaskProvider aur Provider ko import karein
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../theme.dart';

// FIX 2: Date comparison helper function
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class CompactCalendarView extends StatefulWidget {
  const CompactCalendarView({super.key});

  @override
  State<CompactCalendarView> createState() => _CompactCalendarViewState();
}

class _CompactCalendarViewState extends State<CompactCalendarView> {
  // Use today's date as the initial focused month
  DateTime _focusedDay = DateTime.now();
  // FIX 3: Selected day ko track karein, shuru mein aaj ka din select karein
  DateTime _selectedDay = DateTime.now();

  // Simple function to navigate months
  void _changeMonth(int change) {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + change, 1);
      // Month change karne par selected day ko usi month ki 1st tarikh par set karein,
      // ya agar woh din exist karta hai toh usi din par rakhein.
      if (_selectedDay.month != _focusedDay.month) {
        _selectedDay = _focusedDay;
      }
    });
  }

  // FIX 4: Selected day ko set karne ka method
  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay; // Jab din select ho toh focused month bhi set ho
    });
  }

  // FIX 5: Selected din ke tasks fetch karne ka helper
  List<Task> _getTasksForSelectedDay(TaskProvider taskProvider) {
    // TaskProvider se saare tasks lein
    return taskProvider.allTasks.where((task) {
      return task.dueDate != null && isSameDay(task.dueDate!, _selectedDay);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    // FIX 7: Theme ko context se lein
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color accentColor = theme.colorScheme.secondary;
    final Color surfaceColor = theme.colorScheme.surface;

    // FIX 6: TaskProvider ko Consumer se wrap karein
    return Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasksForSelectedDay = _getTasksForSelectedDay(taskProvider);

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor, // FIX 7: Background color theme se
            appBar: AppBar(
              title: Text('Calendar View', style: TextStyle(color: textColor)), // FIX 8: Text color theme se
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // --- 1. Month Header and Navigation ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, size: 20),
                          onPressed: () => _changeMonth(-1),
                          color: textColor, // FIX 9: Icon color theme se
                        ),
                        Text(
                          // Format: "October 2025"
                          DateFormat('MMMM yyyy').format(_focusedDay),
                          style: TextStyle( // FIX 10: Text color theme se
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 20),
                          onPressed: () => _changeMonth(1),
                          color: textColor, // FIX 11: Icon color theme se
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- 2. Custom Calendar Grid ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CalendarGrid(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay, // FIX 7: selectedDay pass karein
                      onDaySelected: _onDaySelected, // FIX 8: onDaySelected pass karein
                      allTasks: taskProvider.allTasks, // FIX 9: Tasks pass karein
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 3. Task List for Selected Day ---
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tasks for ${DateFormat('EEE, MMM d').format(_selectedDay)}', // FIX 10: Selected day ka date
                        style: TextStyle(
                          color: accentColor, // FIX 12: Accent color theme se
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  // Actual Task List (Tasks for the selected day would appear here)
                  Container(
                    constraints: const BoxConstraints(minHeight: 200), // Min height diya taakay UI na tootay
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: surfaceColor, // FIX 13: Card background color theme se
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: tasksForSelectedDay.isEmpty
                        ? Padding( // FIX 14: Padding widget ko const hata kar wrap karein
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('No tasks scheduled for this day.', style: TextStyle(color: textColor.withOpacity(0.7))), // FIX 15: Text color theme se
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasksForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final task = tasksForSelectedDay[index];
                        return ListTile(
                          title: Text(task.title, style: TextStyle(color: textColor)), // FIX 16: Text color theme se
                          subtitle: Text(task.priority, style: TextStyle(color: textColor.withOpacity(0.7))), // FIX 17: Text color theme se
                          leading: Icon(
                              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              color: task.isCompleted ? accentColor : textColor.withOpacity(0.6) // FIX 18: Icon color theme se
                          ),
                          // Aap yahan tap par TaskDetailsScreen bhi khol sakte hain
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

// ------------------------------------------------------------------
// Custom Calendar Grid Widget (Updated to use actual tasks)
// ------------------------------------------------------------------
class CalendarGrid extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay; // FIX 11: Selected day
  final Function(DateTime) onDaySelected; // FIX 12: Selection callback
  final List<Task> allTasks; // FIX 13: Task list

  const CalendarGrid({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.allTasks,
  });

  // FIX 14: Actual function to determine if a day has tasks
  int _getTaskCountForDay(DateTime day) {
    return allTasks.where((task) {
      return task.dueDate != null && isSameDay(task.dueDate!, day);
    }).length;
  }

  // FIX 15: Task badging
  bool _hasTasksForDay(DateTime day) {
    return _getTaskCountForDay(day) > 0;
  }

  @override
  Widget build(BuildContext context) {
    // FIX 19: Theme ko context se lein
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;

    final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(focusedDay.year, focusedDay.month);

    final startWeekday = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];

    // --- 1. Weekday Headers (Sun, Mon, Tue...) ---
    // Start week on Sunday (0)
    final weekdayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    dayWidgets.addAll(weekdayNames.map((dayName) => Center(
      child: Text(
        dayName,
        style: TextStyle(color: textColor.withOpacity(0.6), fontWeight: FontWeight.bold), // FIX 20: Text color theme se
      ),
    )).toList());

    // --- 2. Leading empty cells ---
    // Calculate padding needed to align 1st day correctly (Sunday=0, Monday=1, ..., Saturday=6)
    int actualPadding = startWeekday % 7;

    for (int i = 0; i < actualPadding; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // --- 3. Actual Days of the Month ---
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDay = DateTime(focusedDay.year, focusedDay.month, day);
      final isToday = isSameDay(currentDay, DateTime.now());
      final isSelected = isSameDay(currentDay, selectedDay);
      final hasTasks = _hasTasksForDay(currentDay);

      dayWidgets.add(
        GestureDetector(
          onTap: () => onDaySelected(currentDay), // FIX 16: On tap select karein
          child: CalendarDayCell(
            day: day,
            isToday: isToday,
            isSelected: isSelected, // FIX 17: isSelected pass karein
            hasTasks: hasTasks, // FIX 18: hasTasks pass karein
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      children: dayWidgets,
    );
  }
}

// --- Custom Widget for an individual day cell (Updated) ---
class CalendarDayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected; // FIX 19: New property
  final bool hasTasks; // FIX 20: New property

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasTasks,
  });

  @override
  Widget build(BuildContext context) {
    // FIX 21: Theme colors ko lein
    final theme = Theme.of(context);
    final Color accentColor = theme.colorScheme.secondary;
    final Color textColor = theme.colorScheme.onBackground;
    final Color selectedTextColor = theme.brightness == Brightness.dark ? primaryDark : textLight; // Selected day par Dark BG hai, isliye FG light hona chahiye.

    // Determine the color of the circle background
    Color dayBgColor = Colors.transparent;
    Color dayBorderColor = Colors.transparent;

    if (isSelected) {
      dayBgColor = accentColor; // FIX 22: Selected day ka background accent color
      dayBorderColor = accentColor;
    } else if (isToday) {
      dayBgColor = Colors.transparent; // Today ka background transparent
      dayBorderColor = accentColor; // FIX 23: Today ka border accent color
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: dayBgColor,
            shape: BoxShape.circle,
            border: isToday || isSelected ? Border.all(color: dayBorderColor, width: 1) : null,
          ),
          child: Text(
            '$day',
            style: TextStyle(
              // FIX 24: Text color dynamic karein
              color: isSelected ? selectedTextColor : textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // --- Activity Badges (Task Indicators) ---
        if (hasTasks) // FIX 21: taskCount ke bajaye hasTasks use karein
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 2),
            decoration: const BoxDecoration(
              color: priorityHigh, // Use priorityHigh for the dot color (constant)
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}