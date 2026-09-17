import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:hrapp/bulider/actvities.dart';
import 'package:hrapp/common/Reuseable_button.dart';

import 'package:hrapp/view/pages/fromeditscreen2.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Saveleavewid extends StatelessWidget {
  const Saveleavewid({super.key, required this.allleavemodel});

  final Allleavemodel allleavemodel;

  @override
  Widget build(BuildContext context) {
    // Deletecontroller delete = Get.put(Deletecontroller());
    // final allleave = Get.put(Allleavecontroller());
    // final Savedleave = Get.put(Allleavecontroller());

    String date1 = allleavemodel.todate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1).toLowerCase();

    String? newtodate;

    String? to;

    if (todate == "1 jan 0001") {
      newtodate = ""; // You don't need to assign todate again
      to = "";
    } else {
      newtodate = todate;
      to = "to";
    }

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
                      allleavemodel.ishalfday == false
                          ? "${allleavemodel.Leave}"
                          : "Half Day",
                      style: TextStyle(fontSize: 12.sp, color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Trailing status badge
              EditButton(
                onTap: () {
                  Get.to(() => Fromeditscreen2(
                        leavedays: allleavemodel.Leavedays!,
                        allleavemodel: allleavemodel,
                      ));

                  print(allleavemodel.Leavedays);

                  print(allleavemodel.ishalfday);

                  print(allleavemodel.LeaveType);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
