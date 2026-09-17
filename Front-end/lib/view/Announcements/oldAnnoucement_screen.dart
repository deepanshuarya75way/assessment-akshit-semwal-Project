import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/announcement/controllers/AnnouncementController.dart';
import 'package:hrapp/view/Announcements/Announcement_widget/Annoucement_widget.dart';

class ExpiredAnnouncements extends StatelessWidget {
  const ExpiredAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    final Announcement = Get.put(Announcementcontroller());
    return Obx(() => Announcement.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: Announcement.OldannouncementList.length,
            itemBuilder: (context, index) {
              final act = Announcement.OldannouncementList[index];

              return AnnouncementCard(
                title: act.message ?? "",
                message: "",
                date: act.expiryDate!.split(" ")[0] ?? "",
              );
            },
          ));
  }
}
