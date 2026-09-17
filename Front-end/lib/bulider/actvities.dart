import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';

class Activities extends StatelessWidget {
  const Activities({super.key});

  // Function to generate a random color
  // Color getRandomColor() {
  //   Random random = Random();

  //   // Generate random RGB values
  //   int red = random.nextInt(256); // Value between 0-255
  //   int green = random.nextInt(256); // Value between 0-255
  //   int blue = random.nextInt(256); // Value between 0-255

  //   // Return the color
  //   return Color.fromRGBO(red, green, blue, 1.0); // 1.0 means fully opaque
  // }
  Color getRandomBlueShade() {
    final random = Random();
    int blue = 200 + random.nextInt(56); // Range: 200-255 for a bright blue
    return Color.fromRGBO(0, 0, blue, 1); // Pure blue shades
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<Dashboardcontroller>();
    final controller = Get.put(Dashboardcontroller());
    return Obx(() => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal, // Horizontal list
        itemCount: controller.activitieslist.length,

        // controller.activitieslist.length,
        itemBuilder: (context, index) {
          var activity = controller.activitieslist[index];
          return Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 190,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.1),
                  //     blurRadius: 10,
                  //     spreadRadius: 2,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + Title Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Palette.Kmain.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.event_available,
                            size: 18,
                            color: Palette.Kmain,
                          ),
                        ),
                        const SizedBox(
                            width: 8), // Spacing between icon and text
                        Expanded(
                          child: Text(
                            activity.meassage ?? "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins-Medium',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
