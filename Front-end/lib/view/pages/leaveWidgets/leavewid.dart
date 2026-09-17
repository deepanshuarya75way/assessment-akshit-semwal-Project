import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:intl/intl.dart';

class Leaveapproved extends StatelessWidget {
  const Leaveapproved({super.key, this.allleavemodel});

  final Allleavemodel? allleavemodel;

  @override
  Widget build(BuildContext context) {
    String? text;
    if (allleavemodel!.wfstatus == "A") {
      text = "Approved";
    } else {
      text = "Rejected";
    }

    Color? color;

    if (allleavemodel!.wfstatus == 'A' || allleavemodel!.wfstatus == 'a') {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    String date1 = allleavemodel!.todate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    String date = allleavemodel!.fromDate.toString(); 
    DateTime dateTime = DateTime.parse(date);

    String fromdate = DateFormat('d MMM yyyy').format(dateTime);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Container(
          height: 110.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading content
              SizedBox(
                width: 200.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Remarks: ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Palette.KmainDark1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: allleavemodel!.Remarks ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      allleavemodel!.ishalfday == false
                          ? "$fromdate to $todate"
                          : "$fromdate",
                      style:
                          TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      allleavemodel!.ishalfday == false
                          ? "${allleavemodel!.Leave}"
                          : 'Half Day',
                      style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Trailing status badge
              Container(
                height: 30.h,
                width: 90.w,
                decoration: BoxDecoration(
                  border: Border.all(color: color!),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    text!,
                    style: TextStyle(color: color, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
