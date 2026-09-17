import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/announcement/controllers/AnnouncementController.dart';
import 'package:intl/intl.dart';

class UpdateAnnouncementScreen extends StatelessWidget {
  final String title;
  final String message;
  final String publishDate;
  final String expiryDate;
  final bool status;

  final int index;
  final int id;

  UpdateAnnouncementScreen({
    super.key,
    required this.title,
    required this.message,
    required this.publishDate,
    required this.expiryDate,
    required this.id,
    required this.status,
    required this.index,
  }) {
    controller.initData(
      title: title,
      message: message,
      publish: publishDate,
      expiry: expiryDate,
    );
  }

  final controller = Get.put(Announcementcontroller());

  @override
  Widget build(BuildContext context) {
    /// init data (IMPORTANT)

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text("Update Announcement"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Heading
                Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 TextField
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    hintText: "Enter title...",
                    prefixIcon: const Icon(Icons.title),

                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),

                    /// Border styles
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Title Field

            const SizedBox(height: 16),

            /// Message Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Heading
                Text(
                  "Message",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 TextField
                TextField(
                  controller: controller.messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter your message...",
                    prefixIcon: const Icon(Icons.message),

                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),

                    /// 🔹 Default Border
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    /// 🔹 Enabled Border (normal state)
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),

                    /// 🔹 Focus Border (when user clicks)
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400, // 👈 highlight color
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Publish Date
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Heading
                    Text(
                      "Publish Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 🔹 TextField
                    TextFormField(
                      readOnly: true,
                      onTap: () => controller.pickPublishDate(
                          context, controller.publishDate.value),
                      decoration: InputDecoration(
                        hintText: controller.publishDate.value.isEmpty
                            ? "Select Publish Date"
                            : controller.publishDate.value,
                        prefixIcon: const Icon(Icons.calendar_today),

                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        /// 🔹 Enabled Border (normal state)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),

                        /// 🔹 Focus Border (when user clicks)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400, // 👈 highlight color
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 16),

            /// Expiry Date
            ///

            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Heading
                    Text(
                      "Expiry Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 🔹 TextField
                    TextFormField(
                      readOnly: true,
                      onTap: () => controller.pickExpiryDate(
                          context, controller.expiryDate.value),
                      decoration: InputDecoration(
                        hintText: controller.expiryDate.value.isEmpty
                            ? "Select Expiry Date"
                            : controller.expiryDate.value,
                        prefixIcon: Icon(Icons.event),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        /// 🔹 Enabled Border (normal state)
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),

                        /// 🔹 Focus Border (when user clicks)
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400, // 👈 highlight color
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            // Row(
            //   children: [
            //     Obx(() => Checkbox(
            //           value: controller.stat[index],
            //           onChanged: (value) {
            //             controller.stat[index] = value!;
            //           },
            //         )),
            //     const Text("Active"),
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Active",
                  style: TextStyle(fontSize: 14),
                ),
                Obx(() => Switch(
                      value: controller.stat[index],
                      onChanged: (val) => controller.stat[index] = val,
                      activeColor: Colors.green,
                    )),
              ],
            ),

            const SizedBox(height: 30),

            /// Update Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          /// ✅ validation added
                          if (publishDate == null ||
                              expiryDate == null ||
                              controller.titleController.text.isEmpty ||
                              controller.messageController.text.isEmpty) {
                            Get.snackbar("Error", "Fill all fields");
                            return;
                          }

                          controller.UpdatedAnnouncement(
                            controller.titleController.text,
                            controller.messageController.text,
                            publishDate!,
                            expiryDate!,
                            id,
                            controller.stat[index],
                          );
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Announcement",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
