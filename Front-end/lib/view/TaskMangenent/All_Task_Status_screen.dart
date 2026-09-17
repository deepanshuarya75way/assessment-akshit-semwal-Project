import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:hrapp/features/task/models/Task.model.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/AllTaskScreen/All_Inprogess_screen.dart';
import 'package:hrapp/view/TaskMangenent/AllTaskScreen/All_Pending_task_screen.dart';
import 'package:hrapp/view/TaskMangenent/AllTaskScreen/TaskCompeleted_Screen.dart';
import 'package:hrapp/view/TaskMangenent/createTask_sccreen.dart';

class AllTaskStatus extends StatefulWidget {
  @override
  State<AllTaskStatus> createState() => _AllTaskStatusState();
  final int groupId;
  final TaskGroup group;
  AllTaskStatus({
    required this.groupId,
    required this.group,
  });
}

class _AllTaskStatusState extends State<AllTaskStatus> {
  final _controller = ValueNotifier('In Progress');
  final controller = Get.find<TaskControler>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          label: GestureDetector(
            onTap: () {
              Get.to(() => CreateTaskScreen(
                    GroupId: widget.groupId,
                  ));
            },
            child: const Text(
              "Create Task",
              style: TextStyle(fontSize: 14),
            
            
              
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🔥 SEGMENT
          Center(
            child: Container(
              height: 48.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: AdvancedSegment(
                controller: _controller,
                enableDrag: true,
                itemPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                sliderDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Palette.KmainDark1,
                ),
                activeStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                inactiveStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),

                /// ✅ FIXED KEYS
                segments: const {
                  'In Progress': 'In Progress',
                  'Pending': 'Pending',
                  'Completed': 'Completed',
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 CONTENT
          Expanded(
            child: ValueListenableBuilder<String>(
              valueListenable: _controller,
              builder: (context, value, child) {
                switch (value) {
                  case 'In Progress':
                    return _buildInProgress();

                  case 'Completed':
                    return _buildCompleted();

                  case 'Pending':
                    return _buildPending();

                  default:
                    return const Center(child: Text("No Data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ IN PROGRESS
  Widget _buildInProgress() {
    return Obx(() {
      final tasks =
          controller.Inprogresslist.where((t) => t.groupId == widget.groupId)
              .toList();

      if (tasks.isEmpty) {
        return const Center(child: Text("No In Progress Tasks"));
      }

      print(tasks.length);

      return AllInprogessScreen(
        taskModelDetails: tasks,
        id: widget.groupId,
      );
    });
  }

  /// ✅ COMPLETED
  Widget _buildCompleted() {
    return Obx(() {
      final tasks =
          controller.comlist.where((t) => t.groupId == widget.groupId).toList();

      if (tasks.isEmpty) {
        return const Center(child: Text("No Completed Tasks"));
      }

      return CompletedTaskScreen(
        taskModelDetails: tasks,
        id: widget.groupId,
      );
    });
  }

  /// ✅ PENDING
  Widget _buildPending() {
    return Obx(() {
      final tasks =
          controller.Pendinglist.where((t) => t.groupId == widget.groupId)
              .toList();

      if (tasks.isEmpty) {
        return const Center(child: Text("No Pending Tasks"));
      }

      print(tasks.length);

      return AllPendingTaskScreen(
        taskModelDetails: tasks,
        id: widget.groupId,
      );
    });
  }
}
