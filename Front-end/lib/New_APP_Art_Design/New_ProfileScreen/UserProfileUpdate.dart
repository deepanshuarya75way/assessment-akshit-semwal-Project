import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:intl/intl.dart';

class UserProfileUpdateScreen extends StatelessWidget {
  UserProfileUpdateScreen({super.key});

  // final TextEditingController PermanentAddress = TextEditingController();
  // final TextEditingController ContactNumber = TextEditingController();
  // final TextEditingController DOBContoller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final profile = Get.put(Profilecontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Old Password
              TextFormField(
                controller: profile.AddressController
                  ..text = profile.profilemodel.permanentaddress ?? '',
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Permanent Address",
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter new Permanent Address";
                  }
                  return null;
                },
              ),

              SizedBox(height: 18.h),

              /// New Password
              TextFormField(
                controller: profile.ContactNumberController
                  ..text = profile.profilemodel.MobileNo ?? '',
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  prefixIcon: Platform.isIOS
                      ? Icon(Icons.phone_iphone)
                      : Icon(Icons.phone_android_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter new ContactNumber";
                  }

                  return null;
                },
              ),

              SizedBox(height: 18.h),

              TextFormField(
                controller: profile.DOBController
                  ..text = (profile.profilemodel.DOB != null &&
                          profile.profilemodel.DOB!.isNotEmpty)
                      ? (() {
                          try {
                            return DateFormat('dd/MM/yyyy').format(
                              DateFormat('yyyy-MM-dd')
                                  .parse(profile.profilemodel.DOB!),
                            );
                          } catch (e) {
                            return '';
                          }
                        })()
                      : '', // only use the controller
                readOnly: true,
                onTap: () => profile.pickDOB(context),
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your Date of Birth";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30.h),

              /// Submit Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.Kmain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          profile.updateProfile();
                        }
                      },
                      child: profile.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Update Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
