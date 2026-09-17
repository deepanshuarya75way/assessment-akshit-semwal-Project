// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hrapp/Themecolor/Palette.dart';
// import 'package:hrapp/features/task/controllers/TaskController.dart';
// import 'package:hrapp/view/TaskMangenent/New_Create_task_screen.dart';
// import 'package:hrapp/view/TaskMangenent/TaskComment_screen.dart';
// import 'package:hrapp/view/TaskMangenent/Task_Details_Screnn.dart';
// import 'package:hrapp/view/TaskMangenent/Updated_task_screen.dart';
// import 'package:hrapp/view/TaskMangenent/createTask_sccreen.dart';
// import 'package:intl/intl.dart';

// class ActiveTaskScreen extends StatefulWidget {
//   final String groupName;
//   final int groupId;

//   const ActiveTaskScreen({
//     super.key,
//     required this.groupName,
//     required this.groupId,
//   });

//   @override
//   State<ActiveTaskScreen> createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<ActiveTaskScreen> {
//   final TaskControler taskControler = Get.put(TaskControler());

//   @override
//   void initState() {
//     super.initState();
//     taskControler.GetAllTask(widget.groupId);

//     print(widget.groupId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         /// 🔹 Loading
//         if (taskControler.isloading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         /// 🔹 Filter Tasks
//         final filteredTasks =
//             taskControler.Tasklist.where((t) => t.groupId == widget.groupId)
//                 .toList();

//         final ActiveTask = taskControler.Tasklist.where((t) =>
//             (t.isActive == true || t.isActive == 1) &&
//             t.groupId == widget.groupId).toList();

//         /// 🔹 Empty State
//         if (ActiveTask.isEmpty) {
//           return const Center(
//             child: Text("No Task Found"),
//           );
//         }

//         /// 🔹 Task List
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: ActiveTask.length,
//           itemBuilder: (context, index) {
//             final task = ActiveTask[index];

//             final isOverdue = task.dueDate != null &&
//                 DateTime.parse(task.dueDate.toString())
//                     .isBefore(DateTime.now());

//             return GestureDetector(
//               onTap: () {
//                 Get.to(() => TaskDetailsUI(taskModel: ,));
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color:
//                       isOverdue ? Colors.red.withOpacity(0.05) : Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isOverdue
//                         ? Colors.red.withOpacity(0.3)
//                         : Colors.grey.shade200,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.04),
//                       blurRadius: 10,
//                       offset: const Offset(0, 6),
//                     )
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// 🔥 TOP ROW
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             task.taskTitle ?? '',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),

//                         /// 🔥 EDIT BUTTON (BEST POSITION)
//                         /// 🔥 ACTION BUTTONS (Edit + Add Comment)
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             // Edit Button (existing)
//                             GestureDetector(
//                               onTap: () {
//                                 Get.to(() => EditTaskScreen(
//                                       id: task.taskId ?? 0,
//                                       title: task.taskTitle ?? '',
//                                       description: task.taskDescription ?? '',
//                                       priority: task.priority ?? '',
//                                       status: task.status ?? 0,
//                                       isActive: task.isActive ?? false,
//                                       dueDate: task.dueDate ?? '',
//                                     ));
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 9),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.withOpacity(0.08),
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Icon(Icons.edit,
//                                         size: 20, color: Colors.blue),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "Edit",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blue,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 8), // Space between buttons

//                             // NEW: Add Comment Button
//                             // GestureDetector(
//                             //   onTap: () {
//                             //     // TODO: Add your navigation logic here
//                             //     Get.to(() => AddCommentScreen(
//                             //           taskId: task.taskId ?? 0,
//                             //         ));

//                             //     // OR if you want bottom sheet instead:
//                             //     // showModalBottomSheet(...);
//                             //   },
//                             //   child: Container(
//                             //     padding: const EdgeInsets.symmetric(
//                             //         horizontal: 12, vertical: 9),
//                             //     decoration: BoxDecoration(
//                             //       color: Colors.orange.withOpacity(0.08),
//                             //       borderRadius: BorderRadius.circular(14),
//                             //     ),
//                             //     child: const Row(
//                             //       children: [
//                             //         Icon(Icons.comment_outlined,
//                             //             size: 20, color: Colors.orange),
//                             //         SizedBox(width: 4),
//                             //         Text(
//                             //           "Comment",
//                             //           style: TextStyle(
//                             //             fontSize: 12,
//                             //             fontWeight: FontWeight.w600,
//                             //             color: Colors.orange,
//                             //           ),
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     /// 🔹 DESCRIPTION
//                     Text(
//                       task.taskDescription ?? '',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         height: 1.4,
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     /// 🔥 BOTTOM ROW
//                     Row(
//                       children: [
//                         /// 🔹 PRIORITY
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: _priorityColor(task.priority ?? '')
//                                 .withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             task.priority ?? '',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: _priorityColor(task.priority ?? ''),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(width: 8),

//                         /// 🔹 STATUS
//                         _statusChip(task.status ?? 0),

//                         const Spacer(),

//                         /// 🔹 DUE DATE
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.schedule,
//                               size: 14,
//                               color: isOverdue ? Colors.red : Colors.grey,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               _formatDate(task.dueDate),
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600,
//                                 color: isOverdue ? Colors.red : Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                     /// 🔥 OVERDUE LABEL
//                     if (isOverdue)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Text(
//                           "Overdue",
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),

//       /// 🔹 Add Task Button
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Get.to(() => CreateTaskScreen(
//           //       GroupName: widget.groupName,
//           //       GroupId: widget.groupId,
//           //     ));

//           Get.to(() => NewCreateTaskScreen());
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   String _formatDate(dynamic date) {
//     if (date == null) return "";

//     final d = DateTime.parse(date.toString());
//     return DateFormat("d MMMM yyyy").format(d);
//   }

//   /// 🔹 Status Chip (int → UI)
//   Widget _statusChip(int status) {
//     String text;
//     Color color;

//     switch (status) {
//       case 1:
//         text = "Completed";
//         color = Colors.green;
//         break;
//       case 2:
//         text = "In Progress";
//         color = Colors.orange;
//         break;
//       default:
//         text = "Pending";
//         color = Colors.red;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(color: color, fontSize: 12),
//       ),
//     );
//   }

//   /// 🔹 Priority Color
//   Color _priorityColor(String priority) {
//     switch (priority) {
//       case "High":
//         return Colors.red;
//       case "Medium":
//         return Colors.orange;
//       default:
//         return Colors.green;
//     }
//   }
// }
