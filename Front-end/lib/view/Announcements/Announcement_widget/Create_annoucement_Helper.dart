import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/announcement/controllers/AnnouncementController.dart';

class CreateAnnouncementScreen extends StatelessWidget {
  CreateAnnouncementScreen({super.key});

  final controller = Get.put(Announcementcontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text("Create Announcement"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Slidable(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text("Title"),
              const SizedBox(height: 6),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Message
              const Text("Message"),
              const SizedBox(height: 6),
              TextField(
                controller: controller.messageController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Enter message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // const SizedBox(height: 16),

              /// Category
              // const Text("Category"),
              // const SizedBox(height: 6),
              // DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   items: const [
              //     DropdownMenuItem(value: 1, child: Text("General")),
              //     DropdownMenuItem(value: 2, child: Text("Holiday")),
              //     DropdownMenuItem(value: 3, child: Text("Meeting")),
              //   ],
              //   onChanged: (value) {},
              // ),

              // const SizedBox(height: 16),

              /// Target Department
              // const Text("Department"),
              // const SizedBox(height: 6),
              // DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   items: const [
              //     DropdownMenuItem(value: 1, child: Text("HR")),
              //     DropdownMenuItem(value: 2, child: Text("IT")),
              //     DropdownMenuItem(value: 3, child: Text("Finance")),
              //   ],
              //   onChanged: (value) {},
              // ),

              const SizedBox(height: 16),

              /// Publish Date
              const Text("Publish Date"),
              Obx(() => GestureDetector(
                    onTap: () => controller.pickPublishDate(context ,""),
                    child: AbsorbPointer(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: controller.publishDate.value.isEmpty
                              ? "Select Publish Date"
                              : controller.publishDate.value,
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 16),

              /// Expiry Date
              const Text("Expiry Date"),
              const SizedBox(height: 6),
              Obx(() => GestureDetector(
                    onTap: () => controller.pickExpiryDate(context, ""),
                    child: AbsorbPointer(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: controller.expiryDate.value.isEmpty
                              ? "Select Expiry Date"
                              : controller.expiryDate.value,
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  )),

              // Row(
              //   children: [
              //     Obx(
              //       () => Checkbox(
              //         value: controller.isChecked.value == 1,
              //         onChanged: (value) {
              //           controller.isChecked.value = value! ? 1 : 0;
              //         },
              //       ),
              //     ),
              //     const Text("Active"),
              //   ],
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Active",
                    style: TextStyle(fontSize: 14),
                  ),
                  Obx(() => Switch(
                        value: controller.isChecked.value == 1,
                        onChanged: (val) =>
                            controller.isChecked.value = val! ? 1 : 0,
                        activeColor: Colors.green,
                      )),
                ],
              ),

              // const SizedBox(height: 16),

              /// Attachment URL
              // const Text("Attachment URL"),
              // const SizedBox(height: 6),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: "Enter attachment URL",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 30),

              /// Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.titleController.text.isNotEmpty &&
                        controller.messageController.text.isNotEmpty &&
                        controller.publishDate.value.isNotEmpty &&
                        controller.expiryDate.value.isNotEmpty) {
                      controller.CreateAnnouncement();
                    } else {
                      Get.snackbar("Error", "Please fill all the fields");
                    }
                  },
                  child: Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Create Announcement",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
