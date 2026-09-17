import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/approval/models/Approval_detailsModl.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/view/pages/ViewDetailsScreen.dart';

class Approverdetailswid extends StatelessWidget {
  Approverdetailswid({super.key, required this.approvalDetails});

  final ApprovalDetails approvalDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => Viewdetailsscreen(
                approvalDetails: approvalDetails,
              ));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Palette.KmainLight1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              /// Left Icon
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  size: 16,
                  color: Colors.blue,
                ),
              ),

              SizedBox(width: 10),

              /// Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      approvalDetails.screenname ?? "unknow",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      approvalDetails.appdetails ?? "Leave Request",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8),

              /// 🔥 View Button (Right)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  minimumSize: Size(0, 28),
                  side: BorderSide(color: Colors.orange.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Get.to(() => Viewdetailsscreen(
                        approvalDetails: approvalDetails,
                      ));
                },
                child: Text(
                  "View",
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: Colors.orange.shade400,
                    fontWeight: FontWeight.w500,
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
