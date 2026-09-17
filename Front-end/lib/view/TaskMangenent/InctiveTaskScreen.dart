import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/task/models/Task.model.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/Updated_task_screen.dart';
import 'package:hrapp/view/TaskMangenent/createTask_sccreen.dart';

class InActiveTaskScreen extends StatefulWidget {
  final int groupId;
  final TaskGroup taskGroup;

  const InActiveTaskScreen({
    super.key,
    required this.groupId,
    required this.taskGroup,
  });

  @override
  State<InActiveTaskScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<InActiveTaskScreen> {
  final controller = Get.find<TaskControler>();

  @override
  // void initState() {
  //   super.initState();
  //   taskControler.GetAllTask(widget.groupId);
  //   //  print(taskControler.Tasklist.first.isActive);
  //   //  print('active or not ${taskControler.Tasklist.first.isActive}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        /// 🔹 Empty State
        if (controller.inactivelist.isEmpty) {
          return const Center(
            child: Text("No Task Found"),
          );
        }

        /// 🔹 Task List
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.inactivelist.length,
          itemBuilder: (context, index) {
            final task = controller.inactivelist[index];

            print(controller.inactivelist.length);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Title + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.taskTitle ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => EditTaskScreen(
                                createBy: task.assignedBy ?? '',
                                id: task.taskID ?? 0,
                                title: task.taskTitle ?? '',
                                description: task.taskDescription ?? '',
                                priority: task.priority ?? '',
                                status: task.status ?? 0,
                                isActive: false ?? false,
                                assignedToID: task.assignedToId ?? 0,
                                dueDate: task.dueDate ?? '',
                              ));
                          print(" testing ${task.assignedToId}");
                          print(task.status);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 20, color: Colors.blue),
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

                  const SizedBox(height: 6),

                  /// 🔹 Description
                  Text(
                    task.taskDescription ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 Priority
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        task.priority ?? '',
                        style: TextStyle(
                          color: _priorityColor(task.priority ?? ''),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.extended(
          backgroundColor: Palette.Kmain,
          foregroundColor: Palette.Kwhite,
          onPressed: () {
            Get.to(() => CreateTaskScreen(
                  GroupId: widget.groupId,
                ));
          },
          icon: const Icon(Icons.task_alt_rounded, size: 20),
          label: const Text(
            "Create Task",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),

      /// 🔹 Add Task Button
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.to(() => CreateTaskScreen(
      //           GroupId: widget.groupId,
      //         ));
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  /// 🔹 Status Chip (int → UI)
  Widget _statusChip(int status) {
    String text;
    Color color;

    switch (status) {
      case 1:
        text = "Completed";
        color = Colors.green;
        break;
      case 2:
        text = "In Progress";
        color = Colors.orange;
        break;
      default:
        text = "Pending";
        color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }

  /// 🔹 Priority Color
  Color _priorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}
