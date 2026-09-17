import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/task/controllers/Comment_Controller.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/Updated_task_screen.dart';
import 'package:intl/intl.dart';

class TaskDetailsUI extends StatelessWidget {
  TaskDetailsUI(
      {super.key,
      required this.taskModel,
      required this.CreateBy,
      required this.taskTITLE,
      required this.priority});
  final TaskModelDetails taskModel;

  final String CreateBy;

  final String taskTITLE;
  final String priority;

  @override
  Widget build(BuildContext context) {
    final isOverdue = taskModel.dueDate != null &&
        DateTime.parse(taskModel.dueDate.toString()).isBefore(DateTime.now());
    CommentController commentController = Get.put(CommentController());
    commentController.ShowComment(taskModel.taskID!);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xfff4f6fb),
        appBar: AppBar(
          title: const Text(
            "Task Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Palette.KmainLight1.withOpacity(0.15),
          elevation: 5,
          excludeHeaderSemantics: true,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Get.to(() => EditTaskScreen(
                  createBy: taskModel.assignedBy ?? '',
                  id: taskModel.taskID ?? 0,
                  title: taskModel.taskTitle ?? '',
                  description: taskModel.taskDescription ?? '',
                  priority: taskModel.priority ?? '',
                  status: taskModel.status ?? 0,
                  isActive: true,
                  dueDate: taskModel.dueDate ?? '',
                  assignedToID: taskModel.assignedToId ?? 0,
                ));

            /// 🔥 THIS IS THE KEY
            if (result == true) {
              await Get.find<TaskControler>().GetTaskGroup(); // refresh API
              Get.back();
            }
          },
          icon: const Icon(Icons.edit, size: 18),
          label: const Text(
            "Edit",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Color(0xFFE8F2FF),
          foregroundColor: Colors.blue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER CARD - IMPROVED
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _cardStyle(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${taskTITLE}",
                              style: TextStyle(
                                fontSize: 15.w,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          // const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildPriorityBadge(taskModel, priority),
                          SizedBox(
                            width: 8.w,
                          ),
                          _Tag("${taskModel.taskType}", Color(0xFF3B82F6),
                              Icons.folder_open),
                          SizedBox(
                            width: 8.w,
                          ),
                          _ActivePriorityBadge(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            formatDate(taskModel.createdDate.toString()),
                            style:
                                TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                          Spacer(),
                          _Tag1(
                              formatDate(taskModel.dueDate.toString()),
                              isOverdue
                                  ? const Color(0xFFEF4444)
                                  : Colors.green,
                              "Due Date",
                              isOverdue),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade300,
                            child: Text(
                              CreateBy[0],
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
                                CreateBy,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Avatar circle
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey.shade300,
                            child: Text(
                              taskModel.assignedTo![0] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                                "${taskModel.assignedTo}",
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
                    ]),
              ),

              /// DESCRIPTION - ENHANCED
              _section(
                "Description",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${taskModel.taskDescription}",
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),

              /// ASSIGNMENT - IMPROVED WITH AVATARS
              // _section(
              //   "Assignment",
              //   Column(
              //     children: [
              //       _assignmentCard(
              //         icon: Icons.person_outline,
              //         title: "Assigned To",
              //         name: "User 5",
              //         role: "Lead Developer",
              //         avatarLetter: "U5",
              //         color: const Color(0xFFE8F0FE),
              //       ),
              //       const SizedBox(height: 12),
              //       _assignmentCard(
              //         icon: Icons.assignment_ind_outlined,
              //         title: "Assigned By",
              //         name: "User 3",
              //         role: "Product Owner",
              //         avatarLetter: "U3",
              //         color: const Color(0xFFF3E8FF),
              //       ),
              //     ],
              //   ),
              // ),

              /// TIMELINE - IMPROVED WITH ICONS AND BETTER VISUAL
              // _section(
              //   "Timeline",
              //   Column(
              //     children: [
              //       _timelineItem(
              //         icon: Icons.calendar_today,
              //         label: "Due Date",
              //         value: formatDate(taskModel.dueDate),
              //         color: const Color(0xFFEF4444),
              //         bgColor: const Color(0xFFFEF2F2),
              //       ),
              //       const SizedBox(height: 12),
              //       _timelineItem(
              //         icon: Icons.create_outlined,
              //         label: "Created",
              //         value: formatDate(taskModel.createdDate.toString()),
              //         color: const Color(0xFF10B981),
              //         bgColor: const Color(0xFFECFDF5),
              //       ),
              //     ],
              //   ),
              // ),
              _section(
                "Comments",
                Column(
                  children: [
                    /// 🔹 COMMENT LIST
                    Obx(() {
                      if (commentController.isloading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (commentController.commentlist.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "No comments yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: commentController.commentlist.length,
                        itemBuilder: (context, index) {
                          final comment = commentController.commentlist[index];
                          return commentItem(
                            name: comment.commenename ?? "",
                            message: comment.commenename ?? "", // ✅ FIXED
                            time: formatDate(
                                comment.commentdate?.toString() ?? ""),
                          );
                        },
                      );
                    }),

                    //  const SizedBox(height: 2),

                    /// 🔹 ADD COMMENT BOX
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController.commentTextController,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        /// 🔥 SEND BUTTON
                        Obx(() {
                          return InkWell(
                            onTap: commentController.isSending.value
                                ? null
                                : () {
                                    final text = commentController
                                        .commentTextController.text
                                        .trim();

                                    if (text.isEmpty) {
                                      Get.snackbar(
                                        "Error",
                                        "Comment cannot be empty",
                                        snackPosition: SnackPosition.bottom,
                                      );
                                      return;
                                    } else {
                                      commentController.addComment(
                                          text, taskModel.taskID!);
                                    }

                                    //  commentController.addComment(text);
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: commentController.isSending.value
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.send, color: Colors.white),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              /// ACTIVITY SECTION - NEW

              // const SizedBox(height: 10),

              // /// ACTION BUTTONS - IMPROVED WITH MULTIPLE OPTIONS
              // Row(
              //   children: [
              //     Expanded(
              //       child: _actionButton(
              //         text: "Edit Task",
              //         icon: Icons.play_arrow,
              //         gradient: const LinearGradient(
              //           colors: [Color(0xff22c55e), Color(0xff16a34a)],
              //         ),
              //         onTap: () {},
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     const SizedBox(width: 8),
              //   ],
              // ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskModelDetails taskM, String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12, color: Color(0xFFD97706)),
          SizedBox(width: 4),
          Text(
            "${priority}",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB45309)),
          ),
        ],
      ),
    );
  }

  Widget _ActivePriorityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Active",
            style: TextStyle(
                fontSize: 12.w,
                fontWeight: FontWeight.w500,
                color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xff3b82f6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff6b7280),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _assignmentCard({
    required IconData icon,
    required String title,
    required String name,
    required String role,
    required String avatarLetter,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                avatarLetter,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xff9ca3af)),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  role,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xff6b7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 14, color: const Color(0xff6b7280)),
          ),
        ],
      ),
    );
  }

  Widget commentItem({
    required String name,
    required String message,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Left Accent Line
          // Container(
          //   width: 4,
          //   height: 50,
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          // ),

          const SizedBox(width: 12),

          // 📝 Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                // Text(
                //   name,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.w600,
                //     fontSize: 14,
                //   ),
                // ),

                const SizedBox(height: 4),

                // Message
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 6),

                // Time
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xff9ca3af)),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required String avatar,
    required String action,
    required String time,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xffe5e7eb),
          child: Text(
            avatar,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xff374151)),
                  children: [
                    TextSpan(
                        text: avatar,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " $action"),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: Color(0xff9ca3af)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(rawDate); // parse ISO or SQL date
      return DateFormat('dd MMM yyyy').format(dt); // e.g., 15 Mar 2026
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }

  Widget _actionButton({
    required String text,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: gradient,
          boxShadow: const [
            BoxShadow(
                blurRadius: 8, offset: Offset(0, 2), color: Colors.black12),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          blurRadius: 12,
          offset: Offset(0, 4),
          color: Colors.black12,
        )
      ],
    );
  }
}

/// IMPROVED TAG WITH ICON
class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _Tag(this.text, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag1 extends StatelessWidget {
  final String text;
  final Color color;
  final String label;
  final bool isOverdue;

  const _Tag1(this.text, this.color, this.label, this.isOverdue);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 14,
            color: isOverdue ? Colors.red : Colors.green,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
