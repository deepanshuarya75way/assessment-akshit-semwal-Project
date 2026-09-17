import 'package:flutter/material.dart';
import 'package:hrapp/features/attendance/models/AttendenceRecords.dart';
import 'package:hrapp/Widget/circle.dart';

class Attendencewid extends StatelessWidget {
  const Attendencewid({super.key, required this.empAttendence});

  final AttendanceRecord empAttendence;

  Color getColorFromStatus(String? status) {
    switch (status) {
      case 'A':
        return Colors.red;
      case 'P':
        return Colors.green;
      case 'WE':
        return Colors.grey;
      case 'H':
        return Colors.orange;
      default:
        return Colors.blue; // For unknown or null
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlackcircleWid(
      text: empAttendence.atnDateDay.toString(),
      color: getColorFromStatus(empAttendence.attnD),
    ));
  }
}
