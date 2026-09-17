import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/New_APP_Art_Design/New_ProfileScreen/App_Drawer.dart';

import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';

import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/features/profile/controllers/UserDeleteAccountControoler.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Userprofile = Get.put(Profilecontroller());
    final Login = Get.put(Logincontroller());
    return Obx(() => Userprofile.isLoading.value
        ? ListView.builder(
            itemCount: 1,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Name
                    Container(
                      width: 160,
                      height: 16,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 10),

                    // Designation
                    Container(
                      width: 120,
                      height: 14,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 30),

                    // Info Cards
                    ...List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          )
        : SafeArea(
            child: Scaffold(
                // appBar: AppBar(
                //   backgroundColor: Colors.white,
                //   leading: Builder(
                //     builder: (context) => IconButton(
                //       icon: const Icon(Icons.menu, color: Colors.black),
                //       onPressed: () {
                //         Scaffold.of(context).openDrawer(); // ✅ works
                //       },
                //     ),
                //   ),
                // ),
         

                // appBar: AppBar(
                //   backgroundColor: Colors.white,
                // ),
                key: Userprofile.scaffoldKey,
                backgroundColor: Colors.grey[100],
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),

                      /// PROFILE IMAGE
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: Userprofile.profileModelReponse
                                        .profilemodel?.userimage !=
                                    null
                                ? "${Rs_hrms_config.imageLink}/${Userprofile.profileModelReponse.profilemodel!.userimage}"
                                : "",
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.grey,
                            ),
                            memCacheWidth: 150,
                            memCacheHeight: 150,
                            cacheKey: Userprofile
                                .profileModelReponse.profilemodel?.userimage,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// NAME
                      Text(
                        "${Userprofile.profileModelReponse.profilemodel?.empname ?? ""}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// DESIGNATION
                      Text(
                        "${Userprofile.profileModelReponse.profilemodel?.designation ?? ""}",
                        style: TextStyle(
                          color: Palette.KmainDark2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// DEPARTMENT
                      Text(
                        "${Userprofile.profileModelReponse.profilemodel?.department ?? ""}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// INFO CARDS
                      buildProfileTile(
                        icon: Icons.person,
                        title: "Full Name",
                        value:
                            "${Userprofile.profileModelReponse.profilemodel?.empname ?? ""}",
                      ),

                      buildProfileTile(
                        icon: Icons.cake,
                        title: "Date of Birth",
                        value:
                            "${Userprofile.profileModelReponse.profilemodel?.DOB ?? ""}",
                      ),

                      buildProfileTile(
                        icon: Platform.isIOS
                            ? Icons.phone_iphone
                            : Icons.phone_android,
                        title: "Contact Number",
                        value:
                            "${Userprofile.profileModelReponse.profilemodel?.MobileNo ?? ""}",
                      ),

                      buildProfileTile(
                        icon: Icons.email,
                        title: "Email Address",
                        value:
                            "${Userprofile.profileModelReponse.profilemodel?.email_work ?? ""}",
                      ),

                      buildProfileTile(
                        icon: Icons.location_on,
                        title: "Current Address",
                        value:
                            "${Userprofile.profileModelReponse.profilemodel?.permanentaddress ?? ""}",
                      ),

                      // const SizedBox(height: 30),

                      /// BUTTON ROW
                      // Row(
                      //   children: [
                      //     /// CHANGE PASSWORD
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           Get.to(() => ChangePasswordScreen());
                      //         },
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(vertical: 14),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(16),
                      //             border: Border.all(color: Palette.KmainLight1),
                      //             color: Colors.white,
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(Icons.lock_outline,
                      //                   color: Palette.primaryBlue),
                      //               const SizedBox(width: 6),
                      //               Text(
                      //                 "Change Password",
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   color: Palette.primaryBlue,
                      //                   fontWeight: FontWeight.w600,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),

                      //     const SizedBox(width: 12),

                      //     /// LOGOUT
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           GetStorage box = GetStorage();
                      //           box.remove("UserId");
                      //           box.remove("isauth");

                      //           Get.off(() => Newloginscreen());
                      //         },
                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(vertical: 14),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(16),
                      //             color: Colors.red,
                      //           ),
                      //           child: const Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(Icons.logout, color: Colors.white),
                      //               SizedBox(width: 6),
                      //               Text(
                      //                 "Logout",
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 13,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: () {
                          // Get.to(() => UserProfileUpdateScreen());

                          showUpdateProfileSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            border: Border.all(
                              color: Palette.Ksecondary,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Palette.Ksecondary,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Palette.Ksecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () {
                          // Get.to(() => ChangePasswordScreen());
                          showChangePasswordSheet(context);
                          // showChangePasswordBottomSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Palette.KmainLight1),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline,
                                  color: Palette.primaryBlue),
                              const SizedBox(width: 6),
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Palette.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// LOGOUT + DELETE ROW
                      Row(
                        children: [
                          // 🔴 Logout Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await clearStoredSession();
                                Login.EmailController.clear();
                                Login.PasswordController.clear();
                                Get.offAll(() => Newloginscreen());
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.red.shade400,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout_rounded,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 🗑 Delete Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => {_confirmDelete(context)},
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.red.shade400),
                                  color: Colors.white,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete_forever_rounded,
                                        color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Version ${Rs_hrms_config.App_version}",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                )),
          ));
  }

  /// Reusable Profile Tile
  Widget buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    IconData? editicon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Palette.KmainDark2,
            child: Icon(icon, color: Palette.KmainLight2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            editicon,
            color: Colors.grey,
            size: 30,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final login = Get.put(Logincontroller());
    final userDeleteController = Get.put(UserDeleteController());

    Get.defaultDialog(
      title: "Delete Account",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      radius: 18,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      content: Obx(
        () => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Are you sure you want to delete your account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 22),
            userDeleteController.isLoading.value
                ? const CircularProgressIndicator(
                    color: Colors.red,
                  )
                : Row(
                    children: [
                      /// Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            Get.backLegacy();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Delete Button
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            login.EmailController.clear();
                            login.PasswordController.clear();

                            await userDeleteController.deleteUser();
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void showChangePasswordSheet(BuildContext context) {
    final profile = Get.put(Profilecontroller()); // your controller
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Title
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Old Password
                TextFormField(
                  controller: profile.OldPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter old password";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                /// 🔹 New Password
                TextFormField(
                  controller: profile.NewPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter new password";
                    }
                    if (value.length < 6) {
                      return "Min 6 characters required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                /// 🔹 Confirm Password
                TextFormField(
                  controller: profile.confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm your password";
                    }
                    if (value != profile.NewPassword.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                /// 🔹 Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.Kmain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: profile.ispasswordchange.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await profile.PasswordChange();
                                profile.OldPassword.clear();
                                profile.NewPassword.clear();
                                profile.confirmPassword.clear();
                                Navigator.pop(context); // close sheet
                              }
                            },
                      child: profile.ispasswordchange.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Update Password",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void showUpdateProfileSheet(BuildContext context) {
    final profile = Get.put(Profilecontroller()); // your controller
    final _formKey = GlobalKey<FormState>();

    /// ⚠️ Important: set initial values ONCE (not inside TextField build)
    profile.AddressController.text =
        profile.profilemodel.permanentaddress ?? '';

    profile.ContactNumberController.text = profile.profilemodel.MobileNo ?? '';

    profile.DOBController.text = (profile.profilemodel.DOB != null &&
            profile.profilemodel.DOB!.isNotEmpty)
        ? (() {
            try {
              return DateFormat('dd/MM/yyyy').format(
                DateFormat('yyyy-MM-dd').parse(profile.profilemodel.DOB!),
              );
            } catch (e) {
              return '';
            }
          })()
        : '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// 🔹 Title
                const Text(
                  "Update Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Permanent Address
                TextFormField(
                  controller: profile.AddressController,
                  decoration: InputDecoration(
                    labelText: "Permanent Address",
                    prefixIcon: const Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Permanent Address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                /// 🔹 Contact Number
                TextFormField(
                  controller: profile.ContactNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    prefixIcon: Platform.isIOS
                        ? const Icon(Icons.phone_iphone)
                        : const Icon(Icons.phone_android_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Contact Number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                /// 🔹 DOB
                TextFormField(
                  controller: profile.DOBController,
                  readOnly: true,
                  onTap: () => profile.pickDOB(context),
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter Date of Birth";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                /// 🔹 Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.Kmain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: profile.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await profile.updateProfile();
                                Navigator.pop(context);
                              }
                            },
                      child: profile.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Update Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
