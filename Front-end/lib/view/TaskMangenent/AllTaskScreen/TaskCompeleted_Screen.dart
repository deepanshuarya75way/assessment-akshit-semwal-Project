import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/view/TaskMangenent/Task_Details_Screnn.dart';
import 'package:hrapp/view/TaskMangenent/Updated_task_screen.dart';
import 'package:intl/intl.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen(
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
        final task = taskModelDetails[index];
        final isOverdue = task.dueDate != null &&
            DateTime.parse(task.dueDate.toString()).isBefore(DateTime.now());
        return GestureDetector(
          onTap: () {
            Get.to(() => TaskDetailsUI(
                  taskModel: task,
                  CreateBy: task.assignedBy ?? '',
                  taskTITLE: task.taskTitle ?? '',
                  priority: task.priority ?? '',
                ));
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
                Text(
                  task.taskDescription ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔥 BOTTOM ROW
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
                    const Spacer(),
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
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// 🔥 OVERDUE LABEL
                // if (isOverdue)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 6),
                //     child: Text(
                //       "Overdue",
                //       style: TextStyle(
                //         color: Colors.red,
                //         fontSize: 10,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   )
                // const SizedBox(height: 10),

                // const SizedBox(height: 10),

                // Row(
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.all(5),
                //       width: MediaQuery.of(context).size.width * 0.5,
                //       decoration: BoxDecoration(
                //           color: Colors.grey.withOpacity(0.1),
                //           borderRadius: BorderRadius.circular(15)),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.person,
                //             size: 14,
                //           ),
                //           SizedBox(
                //             width: 3,
                //           ),
                //           Text(
                //             "Assigned To : ${task.assignedTo ?? ''} ",
                //             style:
                //                 TextStyle(fontSize: 9, color: Colors.grey[600]),
                //           ),
                //         ],
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(height: 10),

                // Row(
                //   children: [
                //     // Icon(
                //     //   Icons.person,
                //     //   size: 14,
                //     // ),
                //     // SizedBox(
                //     //   width: 3,
                //     // ),
                //     // Text(
                //     //   "Created By : ${task.assignedBy ?? ''} ",
                //     //   style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                //     // ),
                //     Spacer(),
                //     Icon(
                //       Icons.calendar_month,
                //       size: 14,
                //     ),
                //     SizedBox(
                //       width: 4,
                //     ),
                //     Text(
                //       _formatDate(task.createdDate ?? ''),
                //       style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                //     ),
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
                        "${task.assignedTo ?? ''}".substring(0, 1),
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
                          "${task.assignedTo ?? ''}",
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
                        "${task.assignedBy ?? ''}".substring(0, 1),
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
                          task.assignedBy ?? '',
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
