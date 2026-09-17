import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/task/controllers/Comment_Controller.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';
import 'package:hrapp/view/TaskMangenent/TaskList_screen.dart';
import 'package:hrapp/view/TaskMangenent/UpdatedGroup.dart';

class ActiveGroupScreen extends StatefulWidget {
  ActiveGroupScreen({super.key});

  @override
  State<ActiveGroupScreen> createState() => _ActiveGroupScreenState();
}

class _ActiveGroupScreenState extends State<ActiveGroupScreen> {
  final taskControler = Get.find<TaskControler>();

  @override
  // @override

  /// 🔥 Common function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Obx(() {
        if (taskControler.isloading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ActiveGroup = taskControler.taskGrouplist
            .where((group) => group.groupIsavtive == true)
            .toList();

        if (ActiveGroup.isEmpty) {
          return const Center(child: Text("No Plans Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: ActiveGroup.length,
          itemBuilder: (context, index) {
            final group = ActiveGroup[index];

            // commentController.Alltaskmodel(ActiveGroup[index].groupId!);

            final pcount = group.pendingTasks?.length ?? 0;
            final inprocess = group.inProgressTasks.length;

            // print('ssgs' + pcount.toString() + '' + inprocess.toString());
            final overdue = group.overdueTasks?.length ?? 0;

            // print('ssgs' +
            //     pcount.toString() +
            //     '' +
            //     inprocess.toString() +
            //     '' +
            //     overdue.toString());

            // final Pendinglist = taskControler.Pendinglist[index];

            // print('pendingCount: $pendingCount');

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => TaskListScreen(
                    groupName: group.groupName ?? '',
                    groupId: group.groupId!,
                    group: group,
                    taskModelDetails: [],
                    Inprogresslist: [],
                    Pendinglist: [],
                  ),
                );
                print('groupId: ${group.groupId}');
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  group.groupName ?? "",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => EditGroupScreen(
                                  groupId: group.groupId!,
                                  groupName: group.groupName!,
                                  description: group.description!,
                                  isActive: group.groupIsavtive!,
                                ));

                            print('groupId: ${group.groupIsavtive}');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// 🔹 DESCRIPTION
                    Text(
                      group.description ?? "No description",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 STATS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox("$pcount", "Pending", Colors.red),
                        _buildStatBox("$inprocess", "In Progress", Colors.blue),
                        _buildStatBox("$overdue", "Overdue", Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

Widget _buildStatBox(String count, String label, Color color) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}
