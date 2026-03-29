import 'package:flutter/material.dart';
import '../taskcontroller.dart';
import 'package:google_fonts/google_fonts.dart';

class PanelProgreso extends StatelessWidget {
  final TasksController controller;

  const PanelProgreso({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final weeklyStats = controller.getWeeklyStats();
    final todayProgress = controller.getTodayProgress();
    final maxTasks = weeklyStats.values.isNotEmpty
        ? weeklyStats.values.reduce((a, b) => a > b ? a : b)
        : 0;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tu Progreso",
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "Próximos 7 días",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: todayProgress,
                      strokeWidth: 8,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color: Theme.of(context).colorScheme.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    "${(todayProgress * 100).toInt()}%",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyStats.entries.map((entry) {
                final dayName = _getDayName(entry.key);
                final heightFactor = maxTasks > 0
                    ? entry.value / maxTasks
                    : 0.0;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        entry.value.toString(),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: entry.value > 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 12,
                        height: 70 * heightFactor + 4, // min height 4
                        decoration: BoxDecoration(
                          color: entry.value > 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: entry.value > 0
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dayName,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (DateTime(date.year, date.month, date.day).isAtSameMomentAs(today)) {
      return "Hoy";
    }

    switch (date.weekday) {
      case 1:
        return "Lun";
      case 2:
        return "Mar";
      case 3:
        return "Mié";
      case 4:
        return "Jue";
      case 5:
        return "Vie";
      case 6:
        return "Sáb";
      case 7:
        return "Dom";
      default:
        return "";
    }
  }
}
