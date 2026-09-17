import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/leave/models/upcomingAndPastleavemodel.dart';
import 'package:intl/intl.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

class Upcomingleavewid extends StatelessWidget {
  const Upcomingleavewid({super.key, required this.upcomingandpastleavemodel});

  final Upcomingandpastleavemodel upcomingandpastleavemodel;

  @override
  Widget build(BuildContext context) {
    Color? color;

    if (upcomingandpastleavemodel.WFStatus == 'A' ||
        upcomingandpastleavemodel.WFStatus == "a") {
      color = Colors.green;
    } else if (upcomingandpastleavemodel.WFStatus == 'P' ||
        upcomingandpastleavemodel.WFStatus == "p") {
      color = Colors.red;
    } else {
      color = Colors.grey;
    }
    String? status;

    if (upcomingandpastleavemodel.WFStatus == 'A' ||
        upcomingandpastleavemodel.WFStatus == 'a') {
      status = "Approved";
    } else if (upcomingandpastleavemodel.WFStatus == 'P' ||
        upcomingandpastleavemodel.WFStatus == 'p') {
      status = "pending";
    } else {
      status = "Rejected";
    }

    String date1 = upcomingandpastleavemodel.ToDate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    String date = upcomingandpastleavemodel.FromDate.toString();
    DateTime dateTime = DateTime.parse(date);

    String formdate = DateFormat('d MMM yyyy').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              // border: Border.all(
              //   color: Colors.grey,
              // ),
              // borderRadius: BorderRadius.circular(20),
              ),
          child: ListTile(
            title: Text("${upcomingandpastleavemodel.LeaveType}"),
            subtitle: Text(" $formdate  To  $todate "),
            trailing: Container(
              height: 30.h,
              width: 80.w,
              // color: color,
              decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${status}",
                    style: TextStyle(color: color),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
