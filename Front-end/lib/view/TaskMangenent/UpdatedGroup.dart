import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

class EditGroupScreen extends StatelessWidget {
  final int groupId;
  final String groupName;
  final String description;
  final bool isActive;

  EditGroupScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskControler>();

    /// 🔹 Prefill data
    taskController.UpdatetaskTitlecontroller.text = groupName;
    taskController.UpdatetaskDescriptioncontroller.text = description;
    taskController.isTask.value = isActive;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        title: const Text("Edit Plan"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔥 CARD CONTAINER
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    /// 🔹 ICON
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.view_kanban_rounded,
                          size: 28, color: Colors.blue),
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 GROUP NAME
                    TextField(
                      controller: taskController.UpdatetaskTitlecontroller,
                      decoration: InputDecoration(
                        labelText: "Plan Name",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 DESCRIPTION
                    TextField(
                      controller:
                          taskController.UpdatetaskDescriptioncontroller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 ACTIVE SWITCH
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Active"),
                              Switch(
                                value: taskController.isTask.value,
                                onChanged: (value) =>
                                    taskController.isTask.value = value,
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Palette.Kmain,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (taskController
                              .UpdatetaskTitlecontroller.text.isEmpty ||
                          taskController
                              .UpdatetaskTitlecontroller.text.isEmpty) {
                        Get.snackbar("Error", "Fill all fields");
                        return;
                      }

                      /// 👉 Call Update API
                      // taskController.updateGroupTask(groupId);

                      taskController.updateTask(groupId);

                      print(taskController.isTask.value);
                      print(groupId);
                      print("update");

                      // Get.back();
                    },
                    child: Obx(
                      () => taskController.isloading.value
                          ? const CircularProgressIndicator()
                          : const Text("Update plan"),
                    )),
              ),

              const SizedBox(height: 10),

              /// 🔥 DELETE BUTTON (OPTIONAL)
              // SizedBox(
              //   width: double.infinity,
              //   child: OutlinedButton(
              //     style: OutlinedButton.styleFrom(
              //       padding: const EdgeInsets.symmetric(vertical: 14),
              //       side: const BorderSide(color: Colors.red),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //     ),
              //     onPressed: () {
              //       /// 👉 delete logic
              //       // taskController.deleteGroup(groupId);

              //       Get.back();
              //     },
              //     child: const Text(
              //       "Delete Group",
              //       style: TextStyle(color: Colors.red),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
