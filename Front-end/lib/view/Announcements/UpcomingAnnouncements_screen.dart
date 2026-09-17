import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/announcement/controllers/AnnouncementController.dart';

import 'package:hrapp/view/Announcements/Updated_Annoucment_screen.dart';
import 'package:intl/intl.dart';

class UpcomingAnnouncements extends StatelessWidget {
  const UpcomingAnnouncements({super.key});

  @override
  Widget build(BuildContext context) {
    final announcementCtrl = Get.put(Announcementcontroller());

    String formatDate(String? date) {
      if (date == null || date.trim().isEmpty) {
        return "N/A";
      }

      date = date.trim();

      /// 🔹 1. Check if already in format: 03-May-2026
      final regex = RegExp(r'^\d{2}-[A-Za-z]{3}-\d{4}$');

      if (regex.hasMatch(date)) {
        return date; // ✅ already formatted
      }

      /// 🔹 2. Try parsing
      try {
        DateTime parsedDate = DateTime.parse(date);
        return DateFormat('dd-MMM-yyyy').format(parsedDate);
      } catch (_) {
        try {
          DateTime parsedDate = DateFormat("dd MMM yyyy").parse(date);
          return DateFormat('dd-MMM-yyyy').format(parsedDate);
        } catch (_) {
          return "Invalid Date";
        }
      }
    }

    String formatDate1(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return '';

      try {
        // ✅ Try ISO first (2026-05-03)
        DateTime dt = DateTime.parse(rawDate);
        return DateFormat('d MMM yyyy').format(dt);
      } catch (_) {
        try {
          // ✅ Try backend format (03-May-2026)
          DateTime dt = DateFormat('dd-MMM-yyyy').parse(rawDate);
          return DateFormat('d MMM yyyy').format(dt);
        } catch (e) {
          return rawDate; // fallback
        }
      }
    }

    return Obx(() {
      if (announcementCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (announcementCtrl.announcementList.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "No New Announcement",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemCount: announcementCtrl.announcementList.length,
              itemBuilder: (context, index) {
                var status = announcementCtrl.stat[index];
                var act = announcementCtrl.announcementList[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TOP ROW: Title + Edit Button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Expanded(
                              child: Text(
                                act.title ?? "",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(width: 10.w),

                            /// EDIT BUTTON
                            GestureDetector(
                              onTap: () {
                                Get.to(() => UpdateAnnouncementScreen(
                                      title: '${act.title}',
                                      message: '${act.message}',
                                      publishDate: '${act.publishDate}',
                                      expiryDate: '${act.expiryDate}',
                                      id: act.id!,
                                      status: status!,
                                      index: index,
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit,
                                        size: 18, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 6.h),

                        /// MESSAGE
                        Text(
                          act.message ?? "",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 10.h),

                        /// PUBLISH & EXPIRY DATES
                        Row(
                          children: [
                            /// Publish Date
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Publish Date",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatDate1(act.publishDate!),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Spacer(),

                            /// Expiry Date
                            Row(
                              children: [
                                Icon(Icons.access_time_outlined,
                                    size: 14, color: Colors.red.shade400),
                                const SizedBox(width: 6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Expiry Date",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatDate1(act.expiryDate!),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// DIVIDER
                        const Divider(height: 24),

                        /// CREATED BY
                        Row(
                          children: [
                            /// Avatar Circle with Initials
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(0xFFEEEDFE),
                              child: Text(
                                _getInitials(act.createdBy ?? ""),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF534AB7),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Created By",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  act.createdBy ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );

                /// Helper to get initials from full name

                /// Helper to get initials from full name
              },
            ),
          ),
        ],
      );
    });
  }
}

String _getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  } else if (parts.length == 1 && parts[0].isNotEmpty) {
    return parts[0][0].toUpperCase();
  }
  return '';
}
