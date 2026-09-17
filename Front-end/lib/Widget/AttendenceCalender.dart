import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/attendance/models/AttendenceRecords.dart';

class AttendanceCalendar extends StatelessWidget {
  final List<AttendanceRecord> records;
  final DateTime month;

  const AttendanceCalendar({
    super.key,
    required this.records,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    // Group by week number
    final Map<int, List<AttendanceRecord>> weeks = {};

    for (final record in records) {
      if (record.weekNumber == null) continue;
      weeks.putIfAbsent(record.weekNumber!, () => []).add(record);
    }

    final sortedWeeks = weeks.keys.toList()..sort();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWeekdayHeaders(),
          const SizedBox(height: 6),
          ...sortedWeeks.map((w) => _buildWeekRow(weeks[w]!)),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    return Row(
      children: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// Build one week row
  Widget _buildWeekRow(List<AttendanceRecord> weekRecords) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        children: List.generate(7, (index) {
          final dayRecord = weekRecords.firstWhere(
            (r) => _calculateWeekdayIndex(r.atnDate) == index,
            orElse: () => AttendanceRecord(atnDateDay: null),
          );

          return Expanded(
            child: dayRecord.atnDateDay != null
                ? _buildDayCell(dayRecord)
                : const SizedBox.shrink(),
          );
        }),
      ),
    );
  }

  /// Convert Date → Sunday-based index (0–6)
  int _calculateWeekdayIndex(DateTime? date) {
    if (date == null) return -1;

    // Dart: Mon=1 ... Sun=7
    // We want: Sun=0 ... Sat=6
    return date.weekday % 7;
  }

  Widget _buildDayCell(AttendanceRecord record) {
    final color = _getStatusColor(record.attnD ?? '');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          Container(
            height: 39.h,
            width: 35.w,
            decoration: BoxDecoration(
                color: color,
                // borderRadius: BorderRadius.circular(25),
                shape: BoxShape.circle),
            child: Center(
              child: Text(
                record.atnDateDay.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'P':
        return Colors.green;
      case 'A':
        return Colors.red;
      case 'WK':
      case 'WE':
        return Colors.grey;
      case 'H':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }
}
