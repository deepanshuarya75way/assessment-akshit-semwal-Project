import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/authentication/controllers/AppCodeController.dart';
import 'package:hrapp/view/Auth_Screen/Countus_screen.dart';

class UserCheack extends StatelessWidget {
  const UserCheack({super.key});

  @override
  Widget build(BuildContext context) {
    CodeController appCodeController = Get.put(CodeController());
    return Obx(() => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      color: Colors.white),
                  child: Column(
                    children: [
                      Text(
                        "Please Enter  App code",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: appCodeController.appcode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (appCodeController.appcode.text.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please Enter App Code",
                                colorText: Colors.white,
                                backgroundColor: Colors.red,
                              );
                            }
                            appCodeController.checkAppCode();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.Kmain,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: appCodeController.isloading.value
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New User?",
                              style: TextStyle(color: Colors.black)),
                          TextButton(
                            onPressed: () {
                              Get.to(() => Contactusscreen());
                            },
                            child: Text("Sign Up",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
