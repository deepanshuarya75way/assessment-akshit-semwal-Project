import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/ActiveGroup.dart';
import 'package:hrapp/view/TaskMangenent/InActiveGroup.dart';
import 'package:hrapp/view/TaskMangenent/TaskList_screen.dart';
import 'package:hrapp/view/TaskMangenent/createTask_sccreen.dart';

class TaskGroupScreen extends StatelessWidget {
  TaskGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TaskControler taskControler = Get.put(TaskControler());
    taskControler.GetTaskGroup();

    taskControler.GetTaskType();

    Logincontroller logincontroller = Get.put(Logincontroller());

    logincontroller.AllEmployee();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: FloatingActionButton.extended(
              backgroundColor: Palette.Kmain,
              foregroundColor: Palette.Kwhite,
              onPressed: () {
                showAddGroupSheet(context);
              },
              icon: const Icon(Icons.task_alt_rounded, size: 20),
              label: const Text(
                "Add Plan",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              "Plans",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Palette.KmainLight1.withOpacity(0.15),
            elevation: 5,
            excludeHeaderSemantics: true,
            centerTitle: true,
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey.shade700,
              labelColor: Palette.KmainDark1,
              indicatorColor: Palette.KmainDark2,
              indicatorWeight: 5.0,
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 8,
              ),
              tabs: [
                Tab(text: "Active Plans"),
                Tab(text: "Inactive Plans")
                // Tab(text: "Rejected"),
                // Tab(text: "HalfDay"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ActiveGroupScreen(),
              InActiveGroupScreen(),
            ],
          ),
        ));
  }
}

void showAddGroupSheet(BuildContext context) {
  final TaskControler taskControler = Get.put(TaskControler());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Title
                const Text(
                  "Create Task Plan ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Group Name
                TextField(
                  controller: taskControler.groupName,
                  decoration: InputDecoration(
                    labelText: "Plan Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔹 Description
                TextField(
                  controller: taskControler.description,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔹 Active Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Active"),
                    Obx(
                      () => Switch(
                        value: taskControler.isTask.value,
                        onChanged: (value) {
                          taskControler.isTask.value = value;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔹 Save Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: taskControler.isloading.value
                          ? null
                          : () {
                              if (taskControler.groupName.text.isNotEmpty &&
                                  taskControler.description.text.isNotEmpty) {
                                taskControler.CreateGroupTask();
                                taskControler.groupName.clear();
                                taskControler.description.clear();
                                Navigator.pop(context);
                              } else {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all the fields",
                                );
                              }
                            },
                      child: taskControler.isloading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Save"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
