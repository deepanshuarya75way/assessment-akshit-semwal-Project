import 'dart:async';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

class CreateTaskScreen extends StatelessWidget {
  CreateTaskScreen({super.key, required this.GroupId});

  final int GroupId;

  // final titleController = TextEditingController();
  // final descController = TextEditingController();

  // String priority = "Medium";
  // String TaskType = "Development";
  final _formKey = GlobalKey<FormState>();

  /// 🔧 HELPERS
  Color _getPriorityColor(String value) {
    switch (value) {
      case "Low":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "High":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String value) {
    switch (value) {
      case "Low":
        return Icons.arrow_downward;
      case "Medium":
        return Icons.remove;
      case "High":
        return Icons.priority_high;
      default:
        return Icons.flag;
    }
  }

  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    TaskControler taskControler = Get.put(TaskControler());
    Logincontroller logincontroller = Get.put(Logincontroller());
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.KmainLight1.withOpacity(0.15),
          title: const Text("Create Task"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// 🔷 CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      /// 🔹 TITLE
                      TextFormField(
                        controller: taskControler.taskTitlecontroller,
                        validator: (v) =>
                            v!.isEmpty ? "Enter task title" : null,
                        decoration: InputDecoration(
                          labelText: "Task Title",
                          prefixIcon: Icon(Icons.task),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// 🔹 DESCRIPTION
                      TextFormField(
                        controller: taskControler.taskDescriptioncontroller,
                        maxLines: 3,
                        validator: (v) =>
                            v!.isEmpty ? "Enter description" : null,
                        decoration: InputDecoration(
                          labelText: "Description",
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// 🔹 PRIORITY (PRO UI)
                      DropdownButtonFormField<String>(
                        value: taskControler.priority1.isEmpty
                            ? null
                            : taskControler.priority1,
                        validator: (v) => v == null ? "Select priority" : null,
                        items: ["Low", "Medium", "High"].map((e) {
                          final color = _getPriorityColor(e);
                          final icon = _getPriorityIcon(e);

                          return DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Icon(icon, color: color, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  e,
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          taskControler.priority1 = v!;
                        },
                        decoration: InputDecoration(
                          labelText: "Priority",
                          prefixIcon: Icon(Icons.flag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      /// 🔥 PRIORITY BADGE

                      const SizedBox(height: 14),

                      /// 🔹 ASSIGNED TO (WITH AVATAR)
                      // DropdownButtonFormField<dynamic>(
                      //   value: selectedUser,
                      //   // initialValue: selectedUser,
                      //   validator: (v) => v == null ? "Select user" : null,
                      //   items: logincontroller.emplist.map((e) {
                      //     return DropdownMenuItem(
                      //       value: e,
                      //       child: Row(
                      //         children: [
                      //           CircleAvatar(
                      //             radius: 12,
                      //             backgroundColor: Colors.blue.shade100,
                      //             child: Text(
                      //               e.empName!.trim()[0].toUpperCase(),
                      //               style: TextStyle(color: Colors.blue),
                      //             ),
                      //           ),
                      //           const SizedBox(width: 8),
                      //           Text(e.empName!),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (v) {
                      //     selectedUser = v;

                      //     taskControler.assginedTo =
                      //         v.id; // <-- use your actual id field
                      //     // taskControler.assginedTo = v! as int;
                      //   },
                      //   decoration: InputDecoration(
                      //     labelText: "Assigned To",
                      //     prefixIcon: Icon(Icons.person),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                      DropDownTextField(
                        enableSearch: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Select task type" : null,
                        dropDownItemCount: logincontroller.emplist.value.length,
                        dropDownList: logincontroller.emplist.value
                            .map((e) => DropDownValueModel(
                                name: e.empName!, value: e.id!))
                            .toList(),
                        textFieldDecoration: InputDecoration(
                          labelText: "Assigned To",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          if (val is DropDownValueModel) {
                            taskControler.assginedTo = val.value as int;
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      // /// 🔹 ASSIGNED BY
                      TextFormField(
                        initialValue: profilecontroller.profilemodel.empname ??
                            "Current User",
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Assigned By",
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// 🔹 TASK TYPE
                      DropDownTextField(
                        enableSearch: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Select task type" : null,
                        dropDownItemCount:
                            taskControler.taskmodellist.value.length,
                        dropDownList: taskControler.taskmodellist.value
                            .map((e) => DropDownValueModel(
                                name: e.TaskType!, value: e.id!))
                            .toList(),
                        textFieldDecoration: InputDecoration(
                          labelText: "Task Type",
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          if (val is DropDownValueModel) {
                            taskControler.TaskTypeId = val.value as int;
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      /// 🔹 DUE DATE
                      Obx(() => GestureDetector(
                            onTap: () => taskControler.pickPublishDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                validator: (_) =>
                                    taskControler.publishDate.value.isEmpty
                                        ? "Select due date"
                                        : null,
                                decoration: InputDecoration(
                                  hintText:
                                      taskControler.publishDate.value.isEmpty
                                          ? "Select Due Date"
                                          : taskControler.publishDate.value,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          )),

                      const SizedBox(height: 14),

                      /// 🔹 STATUS (PRO SWITCH STYLE)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Active",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Obx(() => Switch(
                                  value: taskControler.isTaskActive.value,
                                  activeColor: Colors.green,
                                  onChanged: (v) {
                                    taskControler.isTaskActive.value = v;
                                  },
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        taskControler.createTask(GroupId);
                        // taskControler.publishDate.value = "";
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please fill all required fields",
                        );
                      }
                    },
                    child: Obx(() => taskControler.isloading1.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: const CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : const Text(
                            "Create Task",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )),
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
