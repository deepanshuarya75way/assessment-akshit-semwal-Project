import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/dashboard/models/DashboardModel.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:http/http.dart';

class Leavedatawid extends StatelessWidget {
  const Leavedatawid({super.key, required this.leaveDataModel});

  final LeaveDataModel leaveDataModel;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());
    // Color getRandomColorfortext() {
    //   final Random random = Random();
    //   return Color.fromARGB(
    //     255, // Full opacity
    //     random.nextInt(256), // Random red value
    //     random.nextInt(256), // Random green value
    //     random.nextInt(256), // Random blue value
    //   );
    // }
    Color getRandomBlueShade() {
      final random = Random();
      int blue = 200 + random.nextInt(56); // Range: 200-255 for a bright blue
      return Color.fromRGBO(0, 0, blue, 1); // Pure blue shades
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
          //     spreadRadius: 5, // Spread radius (how wide the shadow is)
          //     blurRadius: 10, // Blur radius (how soft the shadow is)
          //     offset: Offset(0, 3), // Shadow position (x, y)
          //   ),
          // ],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          // onTap: ontap,
          child: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: getRandomBlueShade(),
                    child: Text(
                      '${leaveDataModel.balance}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(height: 8), // Add space between CircleAvatar and Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${leaveDataModel.leavetypes}',
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
