import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';

import 'package:hrapp/view/TaskMangenent/Task_Details_Screnn.dart';
import 'package:hrapp/view/TaskMangenent/Updated_task_screen.dart';
import 'package:intl/intl.dart';

class AllPendingTaskScreen extends StatelessWidget {
  const AllPendingTaskScreen(
      {super.key, required this.id, required this.taskModelDetails});

  final int id;

  final List<TaskModelDetails> taskModelDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      itemCount: taskModelDetails.length,
      itemBuilder: (context, index) {
        print(taskModelDetails.length.toString());
        final task = taskModelDetails[index];
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final due = DateTime.parse(task.dueDate.toString());
        final dueDateOnly = DateTime(due.year, due.month, due.day);

        final isOverdue = dueDateOnly.isBefore(today);
        return GestureDetector(
          onTap: () {
            Get.to(() => TaskDetailsUI(
                  CreateBy: task.assignedBy ?? '',
                  taskModel: task,
                  taskTITLE: task.taskTitle ?? '',
                  priority: task.priority ?? '',
                ));
            final isOverdue = task.dueDate != null &&
                DateTime.parse(task.dueDate.toString())
                    .isBefore(DateTime.now());

            print("Task ID122343434343: ${task.taskID}");
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 TOP ROW
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// 🔹 LEFT SIDE (TITLE + PRIORITY)
                    Expanded(
                      child: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: task.taskTitle ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 6),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _priorityColor(task.priority ?? '')
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  task.priority ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _priorityColor(task.priority ?? ''),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// 🔹 RIGHT SIDE (EDIT BUTTON)
                    GestureDetector(
                      onTap: () {
                        Get.to(() => EditTaskScreen(
                              id: task.taskID ?? 0,
                              title: task.taskTitle ?? '',
                              description: task.taskDescription ?? '',
                              priority: task.priority ?? '',
                              status: task.status ?? 0,
                              isActive: true ?? false,
                              dueDate: task.dueDate ?? '',
                              createBy: task.assignedBy ?? '',
                              assignedToID: task.assignedToId ?? 0,
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
                            Icon(Icons.edit, size: 18, color: Colors.blue),
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

                /// 🔹 DESCRIPTION
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.taskDescription ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 14,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      _formatDate(task.createdDate ?? ''),
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    Spacer(),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 10, vertical: 4),
                    //   decoration: BoxDecoration(
                    //     color: _priorityColor(task.priority ?? '')
                    //         .withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Text(
                    //     task.priority ?? '',
                    //     style: TextStyle(
                    //       fontSize: 11,
                    //       fontWeight: FontWeight.w600,
                    //       color: _priorityColor(task.priority ?? ''),
                    //     ),
                    //   ),
                    // ),
                    // Spacer(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: isOverdue
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: isOverdue ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOverdue ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Row(
                //   children: [
                //     /// 🔹 PRIORITY
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 4),
                //       decoration: BoxDecoration(
                //         color: _priorityColor(task.priority ?? '')
                //             .withOpacity(0.1),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Text(
                //         task.priority ?? '',
                //         style: TextStyle(
                //           fontSize: 11,
                //           fontWeight: FontWeight.w600,
                //           color: _priorityColor(task.priority ?? ''),
                //         ),
                //       ),
                //     ),

                //     const SizedBox(width: 8),

                //     /// 🔹 STATUS
                //     // _statusChip(task.status ?? 0),
                //   ],
                // ),

                Divider(),

                Row(
                  children: [
                    // Avatar circle
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        task.assignedTo![0] ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Label + Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Assigned To",
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${task.assignedTo}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),

                    Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        task.assignedBy![0],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Label + Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          task.assignedBy! ?? "",
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
      },
    ));
  }
}

String _formatDate(dynamic date) {
  if (date == null) return "";

  final d = DateTime.parse(date.toString());
  return DateFormat("d MMMM yyyy").format(d);
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
