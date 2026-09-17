import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/task/models/Task.model.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/view/TaskMangenent/TaskList_screen.dart';
import 'package:intl/intl.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

class EditTaskScreen extends StatefulWidget {
  final int id;
  final String title;
  final String createBy;
  final String description;
  final String priority;
  final int status;
  final bool isActive;
  final String dueDate;
  final int assignedToID;

  const EditTaskScreen({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.isActive,
    required this.dueDate,
    required this.createBy,
    required this.assignedToID,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final controller = Get.find<TaskControler>();

  @override
  void initState() {
    super.initState();

    /// 🔥 CLEAN PREFILL
    controller.setEditData(
      title: widget.title,
      description: widget.description,
      priorityVal: widget.priority,
      statusVal: widget.status,
      isActiveVal: widget.isActive,
      dueDate: widget.dueDate,
      assignedToID: widget.assignedToID,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(" status code${widget.status}");
    final taskControler = Get.find<TaskControler>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Edit Task"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  _label("Title"),
                  _field(
                    controller: controller.titleController,
                    hint: "Enter task title",
                    icon: Icons.description_outlined,
                    readOnly: widget.createBy ==
                            profilecontroller.profilemodel?.empname
                        ? false
                        : true,
                  ),

                  const SizedBox(height: 12),

                  /// DESCRIPTION
                  _label("Description"),
                  _field(
                    controller: controller.descController,
                    hint: "Enter description",
                    icon: Icons.notes,
                    maxLines: 3,
                    readOnly: widget.createBy ==
                            profilecontroller.profilemodel?.empname
                        ? false
                        : true,
                  ),

                  const SizedBox(height: 12),

                  /// PRIORITY
                  _label("Priority"),
                  Obx(() => _dropdown(
                        icon: Icons.flag_outlined,
                        value: controller.priority.value,
                        items: ["High", "Medium", "Low"],
                        onChanged: (val) => controller.priority.value = val!,
                      )),

                  const SizedBox(height: 12),

                  /// STATUS
                  _label("Status"),
                  Obx(() => _dropdown(
                        icon: Icons.sync_alt,
                        value: controller.status.value,
                        items: const [
                          {"value": 1, "label": "Pending"},
                          {"value": 2, "label": "In Progress"},
                          {"value": 3, "label": "Completed"},
                        ],
                        isMap: true,
                        onChanged: (val) => controller.status.value = val,
                      )),

                  const SizedBox(height: 12),

                  _label("Assigned To"),
                  Obx(() => _dropdown(
                        icon: Icons.sync_alt,
                        value: controller.assginedToID.value,
                        items: controller.emplist
                            .map((e) => {"value": e.id, "label": e.empName})
                            .toList(),
                        isMap: true,
                        onChanged: (val) => controller.assginedToID.value = val,
                      )),

                  const SizedBox(height: 12),

                  /// DATE
                  _label("Due Date"),
                  GestureDetector(
                    onTap: widget.createBy ==
                            profilecontroller.profilemodel?.empname
                        ? () => controller.pickDueDate(context, widget.dueDate)
                        : null,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: _box(),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() => Text(
                                  controller.publishDate.value.isEmpty
                                      ? "Select Date"
                                      : DateFormat("d MMM yyyy").format(
                                          DateTime.parse(
                                              controller.publishDate.value),
                                        ),
                                  style: const TextStyle(fontSize: 13),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ACTIVE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Active",
                        style: TextStyle(fontSize: 14),
                      ),
                      Obx(() => Switch(
                            value: controller.isActive.value,
                            onChanged: (val) => controller.isActive.value = val,
                            activeColor: Colors.green,
                          )),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// BUTTON
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.isloading.value
                        ? null
                        : () {
                            controller.updateTaskApi(id: widget.id);

                            controller.GetTaskGroup();
                          },
                    child: controller.isloading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : const Text("Update Task"),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _dropdown({
    required IconData icon,
    required dynamic value,
    required List items,
    required Function(dynamic) onChanged,
    bool isMap = false,
  }) {
    return DropdownButtonFormField(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down),
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade400),
        ),
      ),
      items: isMap
          ? items.map<DropdownMenuItem>((e) {
              return DropdownMenuItem(
                value: e["value"],
                child: Text(
                  e["label"],
                ),
              );
            }).toList()
          : items.map<DropdownMenuItem>((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e.toString()),
              );
            }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

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

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey.shade400,
      ),
    );
  }
}
