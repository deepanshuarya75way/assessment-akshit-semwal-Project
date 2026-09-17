import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:intl/intl.dart';

class Rejectwid extends StatelessWidget {
  const Rejectwid({super.key, required this.allleavemodel});

  final Allleavemodel allleavemodel;

  @override
  Widget build(BuildContext context) {
    String? text;
    if (allleavemodel.wfstatus == "R") {
      text = "Rejected";
    }
    Color? color;

    if (allleavemodel.wfstatus == "R") {
      color = Colors.grey;
    }
    String date1 = allleavemodel.todate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    String date = allleavemodel.todate.toString();
    DateTime dateTime = DateTime.parse(date);

    String fromdate = DateFormat('d MMM yyyy').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 90.h,
          width: 90.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)
              // boxShadow: [
              //   BoxShadow(
              //     color:
              //         Colors.black.withOpacity(0.5), // Shadow color with opacity
              //     spreadRadius: 5, // Spread radius (how wide the shadow is)
              //     blurRadius: 7, // Blur radius (how soft the shadow is)
              //     offset: Offset(0, 3), // Shadow position (x, y)
              //   ),
              // ],
              // border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${allleavemodel.Remarks}",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  " $fromdate To  $todate ",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Container(
              height: 30.h,
              width: 90.w,
              decoration: BoxDecoration(
                  border: Border.all(color: color!),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  text!,
                  style: TextStyle(color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
