import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/view/navbar.dart';
import 'package:hrapp/view/pages/leavedashboard.dart';

class ApprovedPage extends StatelessWidget {
  const ApprovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leave Status',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.w),
          height: 300.h,
          width: 300.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(height: 16.h),
              const Text(
                "Leave Submitted!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Palette.Kmain,
                ),
              ),
              SizedBox(height: 8.h),
              const Text(
                "Your leave request has been successfully submitted.\nPlease wait for it to be processed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(() => Navbar());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text(
                  'Go to Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
