import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/features/dashboard/models/DashboardModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';

class Leavebalance extends StatefulWidget {
  const Leavebalance({
    super.key,
    required this.leaveDataModel,
  });

  final LeaveDataModel leaveDataModel;

  @override
  State<Leavebalance> createState() => _LeavebalanceState();
}

class _LeavebalanceState extends State<Leavebalance> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final balance = widget.leaveDataModel.balance ?? 0;
    final totalBalance = (widget.leaveDataModel.leavedays ?? 0) +
        (widget.leaveDataModel.leavebf ?? 0);

    final taken = widget.leaveDataModel.daystaken ?? 0;
    final remaining = (totalBalance - taken) < 0 ? 0 : (totalBalance - taken);

    double progress = 0;
    if (totalBalance > 0) {
      progress = remaining / totalBalance;
      progress = progress.clamp(0, 1);
    }

    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.Kmain.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    color: Palette.Kmain,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),

                /// Leave Type + Consumed
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.leaveDataModel.leavetypes ?? "Leave Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "$taken Consumed",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Balance Number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$balance ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: Palette.Kmain,
                      ),
                    ),
                    Text(
                      "Remaining",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 8.w),

                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Palette.Kmain,
                  ),
                ),
              ],
            ),

            /// 🔹 Expand Section
            AnimatedCrossFade(
              firstChild: const SizedBox(),
              secondChild: Column(
                children: [
                  SizedBox(height: 16.h),

                  /// Gradient Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.h,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(Palette.Kmain),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Taken: $taken",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        "Total: $totalBalance ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
