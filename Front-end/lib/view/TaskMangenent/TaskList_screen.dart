import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/task/models/Task.model.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/ActiveTaskScreen.dart';
import 'package:hrapp/view/TaskMangenent/All_Task_Status_screen.dart';
import 'package:hrapp/view/TaskMangenent/InctiveTaskScreen.dart';
import 'package:hrapp/view/TaskMangenent/createTask_sccreen.dart';

class TaskListScreen extends StatefulWidget {
  final String groupName;
  final int groupId;
  final List<TaskModelDetails> taskModelDetails;
  final List<TaskModelDetails> Inprogresslist;
  final List<TaskModelDetails> Pendinglist;
  final TaskGroup group;

  const TaskListScreen({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.taskModelDetails,
    required this.Inprogresslist,
    required this.Pendinglist,
    required this.group,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskControler taskControler = Get.put(TaskControler());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.groupName,
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
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 8,
              ),
              tabs: [
                Tab(text: "Active Task"),
                Tab(text: "Inactive Task"),

                // Tab(text: "Rejected"),
                // Tab(text: "HalfDay"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllTaskStatus(
                groupId: widget.groupId,
                group: widget.group,
              ),
              InActiveTaskScreen(
                taskGroup: widget.group,
                groupId: widget.groupId,
              )
            ],
          ),
        ));
  }
}

  /// 🔹 Status Chip (int → UI)

