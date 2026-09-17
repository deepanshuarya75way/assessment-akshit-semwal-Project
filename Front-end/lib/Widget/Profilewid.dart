import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/common/ProfileTile.dart';
import 'package:hrapp/common/drawer.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:shimmer/shimmer.dart';

class Profilewid extends StatelessWidget {
  const Profilewid({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.lazyPut<Profilecontroller>(() => Profilecontroller());

    // final profile = Get.find<Profilecontroller>();
    final profile = Get.put(Profilecontroller());

    // profile.GetProfile();

    return Obx(() {
      if (profile.isLoading.value) {
        return ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Added padding for spacing
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  direction: ShimmerDirection.ttb, // Top to Bottom
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.white,
                  ),
                ));
          },
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profile.profileModelReponse.profilemodel
                                        ?.userimage !=
                                    null
                                ? "${Rs_hrms_config.imageLink}/${profile.profileModelReponse.profilemodel!.userimage}"
                                : "",

                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,

                            // ✅ Smooth fade-in
                            fadeInDuration: const Duration(milliseconds: 250),

                            // ✅ Prevent layout jump
                            placeholder: (context, url) => const SizedBox(
                              width: 70,
                              height: 70,
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),

                            // ✅ Clean fallback avatar
                            errorWidget: (context, url, error) =>
                                const SizedBox(
                              width: 70,
                              height: 70,
                              child: Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey,
                              ),
                            ),

                            // ✅ Memory optimization
                            memCacheWidth: 150,
                            memCacheHeight: 150,

                            // ✅ Prevent unnecessary reload
                            cacheKey: profile
                                .profileModelReponse.profilemodel?.userimage,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CommonTile(
                          title: 'Name',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.empname}',
                          icon: Icon(
                            Icons.person,
                            color: Color(0xFF0A1D48),
                          ),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        SizedBox(height: 10),
                        CommonTile(
                          title: 'Department',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.designation}',
                          icon: Icon(Icons.email, color: Color(0xFF0A1D48)),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        // SizedBox(height: 20),
                        // commontile(
                        //   title: '',
                        //   subtitle:
                        //       "${profile.profileModelReponse.profilemodel?.designation}",
                        //   icon: Icon(
                        //       profile.profileModelReponse.profilemodel
                        //                   ?.gender ==
                        //               "Male"
                        //           ? Icons.male
                        //           : Icons.female,
                        //       color: Color(0xFF0A1D48)),
                        // ),
                        SizedBox(height: 10),
                        CommonTile(
                          title: 'Designation',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.department}',
                          icon: Icon(Icons.apartment, color: Color(0xFF0A1D48)),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        SizedBox(height: 10),
                        CommonTile(
                          title: 'E-mail',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.email_work}',
                          icon: Icon(Icons.work, color: Color(0xFF0A1D48)),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        SizedBox(height: 10),
                        CommonTile(
                          title: 'Current Address',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.currentaddress}',
                          icon:
                              Icon(Icons.location_on, color: Color(0xFF0A1D48)),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        SizedBox(height: 10),
                        CommonTile(
                          title: 'Permanent Address',
                          subtitle:
                              '${profile.profileModelReponse.profilemodel?.permanentaddress}',
                          icon:
                              Icon(Icons.location_on, color: Color(0xFF0A1D48)),
                          iconBackgroundColor:
                              Color(0xFF0A1D48).withOpacity(0.1),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        // commontile(
                        //   title: '',
                        //   subtitle: '',
                        //   icon: Icon(
                        //     Icons.location_on,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
