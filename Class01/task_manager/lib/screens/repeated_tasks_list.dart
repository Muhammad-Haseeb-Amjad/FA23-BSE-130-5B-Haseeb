import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// ✅ FIX 1: StatelessWidget se StatefulWidget mein badla
class RepeatedTasksListScreen extends StatefulWidget {
  const RepeatedTasksListScreen({super.key});

  @override
  State<RepeatedTasksListScreen> createState() =>
      _RepeatedTasksListScreenState();
}

class _RepeatedTasksListScreenState extends State<RepeatedTasksListScreen> {
  // ✅ FIX 2: Search Query state variable
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✅ FIX 3: Search bar ko show/hide karne ke liye boolean state
  bool _isSearching = false;

  // Search logic for repeating tasks
  List<Task> _filterTasks(List<Task> allTasks) {
    // Pehle repeating tasks filter karein
    // Show all tasks that have repeat field set (enabled or disabled)
    final repeatedTasks = allTasks
        .where(
          (task) => task.repeat != null && 
                    task.repeat!.isNotEmpty && 
                    task.repeat != 'Does not repeat',
        )
        .toList();

    // Agar search query empty hai toh sabhi repeating tasks wapas karein
    if (_searchQuery.isEmpty) {
      return repeatedTasks;
    }

    // Search query ke mutabik filter karein (case-insensitive)
    final lowerCaseQuery = _searchQuery.toLowerCase();

    return repeatedTasks.where((task) {
      return task.title.toLowerCase().contains(lowerCaseQuery) ||
          (task.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  // --- AppBar Action Button handler ---
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = ''; // Search band hone par query reset karein
        FocusScope.of(context).unfocus(); // Keyboard band karein
      } else {
        // Search shuru hone par focus karein
        FocusScope.of(context).requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color textColor = theme.colorScheme.onBackground;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color accentColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // ✅ FIX 4: Conditional Title/Search Bar
        title: _isSearching
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search repeating tasks...',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: textColor.withOpacity(0.6),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              )
            : Text('Repeating Tasks', style: TextStyle(color: textColor)),

        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // ✅ FIX 5: Search Button
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: textColor,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          // ✅ FIX 6: Filtered list use karein
          final repeatedTasks = _filterTasks(taskProvider.tasks);

          if (repeatedTasks.isEmpty) {
            final String message = _searchQuery.isEmpty
                ? 'No repeating tasks set yet!'
                : 'No results found for "$_searchQuery".';

            return Center(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: repeatedTasks.length,
            itemBuilder: (context, index) {
              final task = repeatedTasks[index];
              // Task card ko koi change nahi chahiye, woh Task object use kar raha hai
              return RepeatingTaskCard(task: task);
            },
          );
        },
      ),
    );
  }
}

// --- Custom Widget for Repeated Task Card (UNCHANGED) ---
class RepeatingTaskCard extends StatefulWidget {
  final Task task;

  const RepeatingTaskCard({super.key, required this.task});

  @override
  State<RepeatingTaskCard> createState() => _RepeatingTaskCardState();
}

class _RepeatingTaskCardState extends State<RepeatingTaskCard> {
  // ... (Content Wahi Rahega) ...
  String _getNextRunDate(String? repeatPattern) {
    if (repeatPattern == 'Daily') {
      return DateFormat(
        'EEE, MMM d',
      ).format(DateTime.now().add(const Duration(days: 1)));
    }
    if (repeatPattern == 'Weekly') {
      return DateFormat(
        'EEE, MMM d',
      ).format(DateTime.now().add(const Duration(days: 7)));
    }
    return 'Custom Run Date';
  }

  // Helper to get priority color (No change needed here, as priorityHigh/Medium/Low are constants)
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return priorityHigh;
      case 'Medium':
        return priorityMedium;
      case 'Low':
        return priorityLow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX 2: Task status ko widget.task se direct lein
    final isEnabled = widget.task.isRepeatingEnabled;

    // FIX 6: Theme colors ko card ke liye lein
    final theme = Theme.of(context);
    final Color surfaceColor = theme.colorScheme.surface; // Card background
    final Color textColor = theme.colorScheme.onSurface; // Text color
    final Color accentColor = theme.colorScheme.secondary;

    final priorityColor = _getPriorityColor(widget.task.priority);
    final nextRunDate = _getNextRunDate(widget.task.repeat);

    // FIX 7: Inactive switch track color
    final Color inactiveTrack = theme.brightness == Brightness.dark
        ? primaryDark
        : const Color(0xFFC0C0C0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: surfaceColor, // FIX 8: Card surface color theme se
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // --- Priority Color Strip (Left) ---
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Title ---
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        // FIX 9: Text color theme se
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // --- Recurrence Pattern Chip ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(
                          0.2,
                        ), // FIX 10: Accent color theme se
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.task.repeat ?? 'N/A',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ), // FIX 11: Accent color theme se
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- Next Run Date ---
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: textColor.withOpacity(0.6),
                        ), // FIX 12: Icon color theme se
                        const SizedBox(width: 5),
                        Text(
                          'Next Run: $nextRunDate',
                          style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontSize: 14,
                          ), // FIX 13: Text color theme se
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- Toggle Enable/Disable ---
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    // FIX 3: Switch value ab model se aayegi
                    value: isEnabled,
                    onChanged: (bool value) {
                      // FIX 4: toggleRepeatingTaskStatus function call karein
                      Provider.of<TaskProvider>(
                        context,
                        listen: false,
                      ).toggleRepeatingTaskStatus(widget.task);

                      // NOTE: Jab TaskProvider notifyListeners() call karega, toh yeh widget auto-rebuild ho jayega.
                    },
                    activeColor: accentColor, // FIX 14: Accent color theme se
                    inactiveThumbColor: textColor.withOpacity(
                      0.5,
                    ), // FIX 15: Thumb color theme se
                    inactiveTrackColor:
                        inactiveTrack, // FIX 16: Track color theme se
                  ),
                  Text(
                    isEnabled
                        ? 'Enabled'
                        : 'Paused', // FIX 5: Text bhi model se
                    style: TextStyle(
                      color: isEnabled
                          ? accentColor
                          : textColor.withOpacity(
                              0.5,
                            ), // FIX 17: Text color theme se
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
