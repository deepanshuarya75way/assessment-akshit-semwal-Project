import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:lottie/lottie.dart';

class Newloginscreen extends StatelessWidget {
  const Newloginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    final Login = Get.put(Logincontroller());
    return Scaffold(
        backgroundColor: Palette.Kwhite,
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                // Top decorative section
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: Palette.Kmain,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Palette.Kmain,
                        Palette.Kmain.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://res.cloudinary.com/dbi2izwfz/image/upload/v1747047453/1_ob4lxw.png",
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.h),
                        // Text(
                        //   "Welcome Back",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 24.sp,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        SizedBox(height: 8.h),
                        // Text(
                        //   "Login to continue",
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.9),
                        //     fontSize: 16.sp,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),

                // Login form section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  child: Transform.translate(
                    offset: Offset(0, -40.h),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Palette.Kmain,
                              ),
                            ),
                            SizedBox(height: 24.h),

                            // Email field
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: TextFormField(
                                controller: Login.EmailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Palette.Kmain,
                                  ),
                                  hintText: "Enter your email",
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Password field
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child: TextFormField(
                                controller: Login.PasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Palette.Kmain,
                                  ),
                                  // suffixIcon: Icon(
                                  //   Icons.visibility_off,
                                  //   color: Colors.grey.shade500,
                                  // ),
                                  hintText: "Enter your password",
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 16.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Forgot password
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: TextButton(
                            //     onPressed: () {},
                            //     child: Text(
                            //       "Forgot Password?",
                            //       style: TextStyle(
                            //         color: Palette.Kmain,
                            //         fontSize: 14.sp,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 16.h),

                            // Login button
                            Login.login.value
                                ? Center(
                                    child: Lottie.asset(
                                        fit: BoxFit.cover,
                                        height: 150.h,
                                        "assets/lottie/Loading.json"),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (Login.EmailController.text
                                                .isNotEmpty &&
                                            Login.PasswordController.text
                                                .isNotEmpty) {
                                          Login.PostLogin();
                                        } else {
                                          Get.snackbar(
                                              backgroundColor:
                                                  Palette.Ksecondary,
                                              colorText: Colors.white,
                                              "Error",
                                              'Please fill all the fields');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.Kmain,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 3,
                                      ),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 24.h),

                            // Sign up option
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(
                            //       "Don't have an account? ",
                            //       style: TextStyle(
                            //         color: Colors.grey.shade600,
                            //         fontSize: 14.sp,
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {},
                            //       child: Text(
                            //         "Sign Up",
                            //         style: TextStyle(
                            //           color: Palette.Kmain,
                            //           fontSize: 14.sp,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
