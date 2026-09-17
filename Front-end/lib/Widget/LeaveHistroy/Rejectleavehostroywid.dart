import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/leave/models/LeaveHistroy.dart';
import 'package:intl/intl.dart';

class Rejectleavehostroywid extends StatelessWidget {
  Rejectleavehostroywid({super.key, required this.leavehistroy});

  Leavehistroy leavehistroy;

  @override
  Widget build(BuildContext context) {
    String? text;
    if (leavehistroy!.wfstatus == "R") {
      text = "Reject";
    }

    Color? color;

    if (leavehistroy!.wfstatus == "R") {
      color = Colors.red;
    }

    String date = leavehistroy!.fromDate.toString();
    DateTime dateTime = DateTime.parse(date);

    String fromdate = DateFormat('d MMM yyyy').format(dateTime);

    String date1 = leavehistroy!.fromDate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 110.h,
        width: 100.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text('$fromdate TO $todate'),
          subtitle: Text("Remark- ${leavehistroy!.Remarks}"),
          trailing: Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.20,
            decoration: BoxDecoration(
                border: Border.all(color: color!),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                text!,
                style: TextStyle(color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
