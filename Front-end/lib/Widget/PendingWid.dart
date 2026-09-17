import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:intl/intl.dart';

class Pendingwid extends StatelessWidget {
  const Pendingwid({super.key, required this.allleavemodel});

  final Allleavemodel allleavemodel;

  @override
  Widget build(BuildContext context) {
    String? statusText;
    Color statusColor;

    // Determine status text and color
    if (allleavemodel.wfstatus == "P" || allleavemodel.wfstatus == 'p') {
      statusText = "Pending";
      statusColor = Colors.amber;
    } else {
      statusText = "";
      statusColor = Colors.grey;
    }

    // Format dates
    String date1 = allleavemodel.todate.toString();
    DateTime dateTime1 = DateTime.parse(date1);
    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    String date = allleavemodel.fromDate.toString();
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
                    Text(
                      "Remark - ${allleavemodel.Remarks}",
                      style: TextStyle(fontSize: 15.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      allleavemodel.ishalfday == true
                          ? "$fromdate"
                          : "$fromdate to $todate",
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      allleavemodel.ishalfday == true
                          ? "Half Day"
                          : "${allleavemodel.Leave}",
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
                  border: Border.all(color: statusColor),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 14.sp),
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
