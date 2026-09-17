import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/announcement/controllers/AnnouncementController.dart';

import 'package:hrapp/view/Announcements/Announcement_widget/Create_annoucement_Helper.dart';
import 'package:hrapp/view/Announcements/UpcomingAnnouncements_screen.dart';

class AnnouncementScreen extends StatelessWidget {
  AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Announcementcontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text("Announcement"),
      ),
      body: UpcomingAnnouncements(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SpeedDial(
          backgroundColor: Palette.Kmain,
          foregroundColor: Palette.Kwhite,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: InkWell(
                onTap: () {
                  // Get.to(() => CreateAnnouncementScreen());
                },
                child: Text("Create Announcement")),
          ),
          label: InkWell(
              onTap: () {
                controller.clearData();
                Get.to(() => CreateAnnouncementScreen());
              },
              child: Text("Create Announcement")),
          childPadding: EdgeInsets.only(top: 20),
          animatedIcon: AnimatedIcons.add_event,
          icon: Icons.add,
          activeIcon: Icons.close,
          buttonSize: Size(45, 45),
          curve: Curves.easeInOut,
          spacing: 10,
          spaceBetweenChildren: 10,
          children: [],
        ),
      ),
    );
  }
}
