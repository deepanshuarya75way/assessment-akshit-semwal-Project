import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/Custom_DropDown.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

class NewCreateTaskScreen extends StatelessWidget {
  const NewCreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TaskControler taskControler = Get.put(TaskControler());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Task"),
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                // const Text(
                //   "Create Task",
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),

                const SizedBox(height: 16),

                /// Task Title
                _buildTextField("Task Title", taskControler.taskTitlecontroller,
                    "Enter task title"),

                const SizedBox(height: 12),

                /// Description
                _buildTextField(
                    "Description",
                    taskControler.taskDescriptioncontroller,
                    "Enter description",
                    maxLines: 3),

                const SizedBox(height: 12),

                /// Priority Dropdown
                _buildDropdown("Priority", "Medium"),

                const SizedBox(height: 12),

                /// Assigned To
                _buildDropdown("Assigned To", "Select user"),

                const SizedBox(height: 12),

                /// Assigned By (Readonly)
                _buildReadOnly("Assigned By",
                    profilecontroller.profilemodel.empname ?? "Current User"),

                const SizedBox(height: 12),

                /// Task Type
                Text("Task Type"),
                SizedBox(
                  height: 5,
                ),
                CustomDropdown(
                  hint: "Select the Task Type",
                  items: taskControler.taskmodellist.value
                      .map((e) => DropDownValueModel(
                            name: e.TaskType!,
                            value: e.id!,
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter task type";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    if (val is DropDownValueModel) {
                      taskControler.TaskTypeId = val.value as int;
                    }
                  },
                ),

                const SizedBox(height: 12),

                /// Due Date
                Text("Due Date"),
                SizedBox(
                  height: 5,
                ),
                Obx(() => GestureDetector(
                      onTap: () => taskControler.pickPublishDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: taskControler.publishDate.value.isEmpty
                                ? "Select Publish Date"
                                : taskControler.publishDate.value,
                            suffixIcon: const Icon(Icons.calendar_today),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    )),

                const SizedBox(height: 12),

                /// Active Toggle
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Active"),
                      Switch(
                        activeColor: Colors.green,
                        value: taskControler.isTaskActive.value,
                        onChanged: (value) {
                          taskControler.isTaskActive.value = value;
                        },
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.KmainDark1,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Create Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// TEXT FIELD
  Widget _buildTextField(
      String label, TextEditingController? controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  /// DROPDOWN
  Widget _buildDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: [value]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }

  /// READ ONLY FIELD
  Widget _buildReadOnly(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  /// DATE FIELD
  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Due Date"),
        const SizedBox(height: 6),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: "mm/dd/yyyy",
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
