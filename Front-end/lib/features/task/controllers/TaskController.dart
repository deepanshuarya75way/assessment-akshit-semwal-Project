import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/authentication/models/LoginModel.dart';
import 'package:hrapp/features/task/models/Task.model.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final taskController = Get.put(TaskControler());

class TaskControler extends GetxController {
  @override
  onInit() {
    GetTaskType();
    GetTaskGroup();
    // allEmployee();
    super.onInit();
  }

  var isloading = false.obs;

  var isloading1 = false.obs;

  //  Create  Task Controller
  var publishDate = "".obs;

  int TaskTypeId = 0;

  RxList<Taskmodel> taskmodellist = <Taskmodel>[].obs;

  String priority1 = "Medium";
  RxString TaskType = "Development".obs;

  Future<void> pickPublishDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: today,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      publishDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  String getGroupName(int id) {
    final group = taskGrouplist.firstWhereOrNull(
      (e) => e.groupId == id,
    );

    return group?.groupName ?? "Unknown";
  }

  TextEditingController groupName = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController authcode = TextEditingController();
  RxBool isTask = false.obs;

  GetStorage box = GetStorage();
  var emplist = <UserData>[].obs;

  Future<void> allEmployee() async {
    try {
      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/EmpName";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "authcode": box.read("AppCode"),
          },
        ),
      );
      if (res.statusCode == 200) {
        emplist.clear();
        final data = jsonDecode(res.body);
        print(data);

        final empName = data["emp_Names"];

        if (empName != null) {
          for (var element in empName) {
            UserData userData = UserData();

            userData.id = element["id"];
            userData.empName = element["EmpName"];

            emplist.add(userData);
          }
        }
        print("emplist $emplist");
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> CreateGroupTask() async {
    isloading.value = true;

    try {
      final Map<String, dynamic> body = {
        "groupName": groupName.text,
        "description": description.text,
        "createdBy": box.read("UserId"),
        "createdDate": DateTime.now().toIso8601String(),
        "isactive": isTask.value,
        "authcode": box.read("AppCode"),
      };

      print(body);
      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      const url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/CreateTaskGroups";

      final res = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode(body));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        print(data);

        final iserror = data["isError"];
        print(iserror);

        if (data["isError"] == false) {
          Get.snackbar(
            "Success",
            "Task Created Successfully",
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
          // Get.back();

          await GetTaskGroup();
        }
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await CreateGroupTask(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {}
    } catch (ex) {
      print(ex.toString());
    } finally {
      isloading.value = false;
    }
  }

  TextEditingController taskTitlecontroller = TextEditingController();
  TextEditingController taskDescriptioncontroller = TextEditingController();
  TextEditingController taskGroupcontroller = TextEditingController();

  RxBool isTaskActive = false.obs;

  int assginedTo = 0;

  Future<void> createTask(int groupId) async {
    // 🔒 Validation
    if (taskTitlecontroller.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Task title is required",
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.orange),
      );
      return;
    }

    String? accessToken = await Rs_hrms_config.storage.read(
      key: "accessToken",
    );

    if (assginedTo == null) {
      Get.snackbar(
        "Validation Error",
        "Please select assigned user",
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        icon: Icon(Icons.person_off, color: Colors.orange),
      );
      return;
    }

    isloading1.value = true;

    try {
      final body = {
        "TaskTitle": taskTitlecontroller.text.trim(),
        "TaskDescription": taskDescriptioncontroller.text.trim(),
        "GroupID": groupId,
        "AssignedTo": assginedTo,
        "AssignedBy": box.read("UserId"),
        "Priority": priority1 ?? "Medium", // ✅ string
        "Status": isActive.value ? 1 : 0, // ✅ FIXED
        "DueDate":
            DateTime.parse(publishDate.value).toIso8601String(), // ✅ FIXED
        "CreatedDate": DateTime.now().toIso8601String(),
        "UpdatedDate": null,
        "IsActive": isTaskActive.value ? 1 : 0,
        "TaskType": TaskTypeId ?? 0,
        "AuthCode": box.read("AppCode"),
      };

      print("body ${jsonEncode(body)}");

      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/CreateTask";
      print("url $url");
      final res = await http
          .post(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $accessToken",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        if (data != null && data["isError"] == false) {
          Future.delayed(Duration.zero, () async {
            // ✅ Snackbar
            Get.snackbar(
              "Success",
              "Task created successfully",
              snackPosition: SnackPosition.bottom,
              backgroundColor: Colors.green.shade100,
              colorText: Colors.green.shade900,
              icon: const Icon(Icons.check_circle, color: Colors.green),
              margin: const EdgeInsets.all(12),
              borderRadius: 8,
              duration: const Duration(seconds: 2),
            );

            taskTitlecontroller.clear();
            taskDescriptioncontroller.clear();

            assginedTo = 0;
            priority1 = "";

            isActive.value = false;
            isTaskActive.value = true;
            publishDate.value = "";
            TaskTypeId = 0;
            await GetTaskGroup(); // 🔥 REFRESH DATA

            Get.back(result: true);
          });
        } else {
          Get.snackbar(
            "Error",
            data["message"] ?? "Something went wrong",
            snackPosition: SnackPosition.bottom,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            icon: const Icon(Icons.error, color: Colors.red),
          );
          print(data["message"]);
          ;
        }
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await createTask(groupId); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Failed with status code ${res.statusCode}",
          snackPosition: SnackPosition.bottom,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          icon: const Icon(Icons.cloud_off, color: Colors.red),
        );
      }
    } catch (ex) {
      debugPrint(ex.toString());
      print("publishDate = '${publishDate.value}'");
      Get.snackbar(
        "Exception",
        ex.toString(),
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        icon: const Icon(Icons.bug_report, color: Colors.red),
      );
    } finally {
      isloading1.value = false;
    }
  }

  Future<void> GetTaskType() async {
    Map<String, dynamic> body = {"authcode": box.read("AppCode")};

    try {
      const url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/MasterApi";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        taskmodellist.clear();
        final data = jsonDecode(res.body);
        print(data);

        final tasktype = data["taskTypeModel"];

        if (tasktype != null) {
          for (var element in tasktype) {
            Taskmodel taskmodel = Taskmodel();

            taskmodel.id = element["id"];
            taskmodel.TaskType = element["tasktype"];
            taskmodellist.add(taskmodel);
          }

          print(taskmodellist.length);
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  RxList<TaskGroup> taskGrouplist = <TaskGroup>[].obs;

  var Pendinglist = <TaskModelDetails>[].obs;

  var Inprogresslist = <TaskModelDetails>[].obs;

  var comlist = <TaskModelDetails>[].obs;
  var overduelist = <TaskModelDetails>[].obs;

  var inactivelist = <TaskModelDetails>[].obs;

  Future<void> GetTaskGroup() async {
    isloading.value = true;

    try {
      const url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/AllGroupsData";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "authcode": box.read("AppCode"),
          "userId": box.read("UserId"),
        }),
      );

      if (res.statusCode == 200) {
        print("list is filling started");

        /// 🔥 TEMP LISTS (IMPORTANT)
        List<TaskGroup> tempGroupList = [];
        List<TaskModelDetails> tempPending = [];
        List<TaskModelDetails> tempInProgress = [];
        List<TaskModelDetails> tempCompleted = [];
        List<TaskModelDetails> tempOverdue = [];
        List<TaskModelDetails> tempInactive = [];

        taskGrouplist.clear();
        Pendinglist.clear();
        Inprogresslist.clear();
        comlist.clear();
        overduelist.clear();
        inactivelist.clear();

        final data = jsonDecode(res.body);
        final taskgroup = data["taskGroupModel"];

        if (taskgroup != null) {
          for (var group in taskgroup) {
            TaskGroup taskGroupObj = TaskGroup();

            taskGroupObj.groupId = group["GroupID"];
            taskGroupObj.groupName = group["GroupName"];
            taskGroupObj.status = group["statusid"];
            taskGroupObj.groupIsavtive = group["GroupIsActive"];
            taskGroupObj.description = group["Description"];
            taskGroupObj.isActive = group["IsActive"];

            List<TaskModelDetails> groupPending = [];
            List<TaskModelDetails> groupInProgress = [];
            List<TaskModelDetails> groupCompleted = [];
            List<TaskModelDetails> groupOverdue = [];
            List<TaskModelDetails> groupInactive = [];

            /// 🔹 Pending
            for (var item in (group["taskPendingsList"] ?? [])) {
              var task = TaskModelDetails();

              task.groupId = group["GroupID"];
              task.taskID = item["TaskID"];
              task.status = item["status"];
              task.assignedToId = item["AssignedTo"];
              task.taskTitle = item["TaskTitle"];
              task.taskDescription = item["TaskDescription"];
              task.priority = item["Priority"];
              task.taskType = item["TaskType"];
              task.dueDate = item["DueDate"]?.toString();
              task.assignedBy = item["AssignedByName"];
              task.assignedTo = item["AssignedToName"];
              task.createdDate = item["CreatedDate"];

              groupPending.add(task);
              tempPending.add(task);
            }

            /// 🔹 Overdue
            for (var item in (group["OverdueTaskList"] ?? [])) {
              var task = TaskModelDetails();

              task.groupId = group["GroupID"];
              task.taskID = item["TaskID"];
              task.status = item["status"];
              task.taskTitle = item["TaskTitle"];
              task.assignedToId = item["AssignedTo"];
              task.taskDescription = item["TaskDescription"];
              task.priority = item["Priority"];
              task.taskType = item["TaskType"];
              task.dueDate = item["DueDate"]?.toString();
              task.assignedTo = item["AssignedToName"];
              task.assignedBy = item["AssignedByName"];
              task.createdDate = item["CreatedDate"];

              groupOverdue.add(task);
              tempOverdue.add(task);
            }

            /// 🔹 In Progress
            for (var item in (group["TaskInprogessList"] ?? [])) {
              var task = TaskModelDetails();

              task.groupId = group["GroupID"];
              task.taskID = item["TaskID"];
              task.status = item["status"];
              task.taskTitle = item["TaskTitle"];
              task.assignedToId = item["AssignedTo"];
              task.taskDescription = item["TaskDescription"];
              task.priority = item["Priority"];
              task.taskType = item["TaskType"];
              task.dueDate = item["DueDate"]?.toString();
              task.assignedTo = item["AssignedToName"];
              task.assignedBy = item["AssignedByName"];
              task.createdDate = item["CreatedDate"];

              groupInProgress.add(task);
              tempInProgress.add(task);
            }

            /// 🔹 Completed
            for (var item in (group["TaskCompletedList"] ?? [])) {
              var task = TaskModelDetails();

              task.groupId = group["GroupID"];
              task.taskID = item["TaskID"];
              task.status = item["status"];
              task.taskTitle = item["TaskTitle"];
              task.assignedToId = item["AssignedTo"];
              task.taskDescription = item["TaskDescription"];
              task.priority = item["Priority"];
              task.taskType = item["TaskType"];
              task.assignedTo = item["AssignedToName"];
              task.dueDate = item["DueDate"]?.toString();
              task.assignedBy = item["AssignedByName"];
              task.createdDate = item["CreatedDate"];

              groupCompleted.add(task);
              tempCompleted.add(task);
            }

            /// 🔹 Inactive
            for (var item in (group["TaskInActiveList"] ?? [])) {
              var task = TaskModelDetails();

              task.groupId = group["GroupID"];
              task.taskID = item["TaskID"];
              task.status = item["status"];
              task.taskTitle = item["TaskTitle"];
              task.assignedToId = item["AssignedTo"];
              task.assignedTo = item["AssignedToName"];
              task.taskDescription = item["TaskDescription"];
              task.priority = item["Priority"];
              task.taskType = item["TaskType"];
              task.dueDate = item["DueDate"]?.toString();
              task.assignedBy = item["AssignedByName"];
              task.createdDate = item["CreatedDate"];

              groupInactive.add(task);
              tempInactive.add(task);
            }

            /// 🔥 Assign to group object
            taskGroupObj.pendingTasks = groupPending;
            taskGroupObj.inProgressTasks = groupInProgress;
            taskGroupObj.completedTasks = groupCompleted;
            taskGroupObj.overdueTasks = groupOverdue;
            taskGroupObj.inActiveTasks = groupInactive;

            tempGroupList.add(taskGroupObj);
          }

          /// 🔥 FINAL ASSIGN (MOST IMPORTANT)
          taskGrouplist.assignAll(tempGroupList);
          Pendinglist.assignAll(tempPending);
          Inprogresslist.assignAll(tempInProgress);
          comlist.assignAll(tempCompleted);
          overduelist.assignAll(tempOverdue);
          inactivelist.assignAll(tempInactive);

          print("Pending: ${Pendinglist.length}");
          print("InProgress: ${Inprogresslist.length}");
          print("Completed: ${comlist.length}");
        } else {
          taskGrouplist.clear();
        }
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await GetTaskGroup(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {}
    } catch (ex) {
      print("ERROR: ${ex.toString()}");
    } finally {
      isloading.value = false;
    }
  }

  RxList<TaskModel> Tasklist = <TaskModel>[].obs;

  Future<void> GetAllTask(int id) async {
    isloading.value = true;
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/AllTaskData?id=$id";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode({"authcode": box.read("AppCode")}));

      if (res.statusCode == 200) {
        Tasklist.clear();
        final data = jsonDecode(res.body);
        print(data);

        final taskgroup = data["taskModels"];

        if (taskgroup != null) {
          for (var element in taskgroup) {
            TaskModel taskModel = TaskModel();

            taskModel.taskId = element["TaskID"];
            taskModel.taskTitle = element["TaskTitle"];
            taskModel.taskDescription = element["TaskDescription"];
            taskModel.groupId = element["GroupID"];
            taskModel.GroupName = element["GroupName"];
            taskModel.taskStatus = element["StatusName"];
            taskModel.taskType = element["TaskTypeName"];
            taskModel.TaskTypeName = element["TaskTypeName"];
            taskModel.assignedBy = element["AssignedToName"];
            taskModel.priority = element["Priority"];
            taskModel.status = element["Status"];
            taskModel.dueDate = element["DueDate"];
            taskModel.createdDate = element["CreatedDate"];
            taskModel.isActive = element["isactive"];
            taskModel.taskType = element["TaskType"];

            Tasklist.add(taskModel);
          }

          print(Tasklist.length);
          print(Tasklist.first.TaskTypeName);
        } else {
          Tasklist.value = [];
        }
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();
        if (success) {
          await GetAllTask(id); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      }
    } catch (ex) {
      print(ex.toString());
    } finally {
      isloading.value = false;
    }
  }

  TextEditingController UpdatetaskTitlecontroller = TextEditingController();
  TextEditingController UpdatetaskDescriptioncontroller =
      TextEditingController();

  Future<void> updateTask(int id) async {
    try {
      isloading.value = true;

      /// 🔹 Validation
      if (UpdatetaskTitlecontroller.text.trim().isEmpty ||
          UpdatetaskDescriptioncontroller.text.trim().isEmpty) {
        Get.snackbar("Error", "All fields are required");
        return;
      }

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UpdatedGroup?id=$id";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "authcode": box.read("AppCode"),
          "GroupName": UpdatetaskTitlecontroller.text.trim(),
          "Description": UpdatetaskDescriptioncontroller.text.trim(),
          "IsActive": isTask.value,
        }),
      );

      /// 🔥 Success
      if (response.statusCode == 200) {
        Get.back(); // close screen

        Get.snackbar(
          "Success",
          "Plan Updated Successfully",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        /// 🔥 Refresh list (IMPORTANT)
        // await fetchTaskGroups(); // make sure you have this

        await GetTaskGroup();
      }

      /// ❌ Error
      else if (response.statusCode == 401) {
        bool success = await refreshApi();
        if (success) {
          await updateTask(id); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      }

      /// ❌ Error
      else {
        Get.snackbar(
          "Error",
          "Failed to update (${response.statusCode})",
          snackPosition: SnackPosition.bottom,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Exception",
        e.toString(),
        snackPosition: SnackPosition.bottom,
      );
    } finally {
      isloading.value = false;
    }
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();

  /// 🔹 State
  var priority = "Medium".obs;
  var status = 0.obs;

  var assginedToID = 0.obs;
  var isActive = true.obs;
  // var publishDate = ''.obs;

  /// 🔹 Prefill Data (BEST PRACTICE)
  void setEditData(
      {required String title,
      required String description,
      required String priorityVal,
      required int statusVal,
      required bool isActiveVal,
      required String dueDate,
      required int assignedToID}) {
    titleController.text = title;
    descController.text = description;

    priority.value = priorityVal;
    status.value = statusVal;
    isActive.value = isActiveVal;

    assginedToID.value = assignedToID;

    /// 🔥 Important
    publishDate.value = dueDate;
  }

  /// 🔹 Date Picker
  Future<void> pickDueDate(BuildContext context, String date) async {
    DateTime today = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date == "" ? DateTime.now() : DateTime.parse(date),
      firstDate: today,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      publishDate.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  /// 🔹 API CALL
  Future<void> updateTaskApi({
    required int id,
  }) async {
    try {
      isloading.value = true;

      final body = {
        "authcode": box.read("AppCode"),
        "TaskID": id,
        "TaskTitle": titleController.text,
        "TaskDescription": descController.text,
        "Priority": priority.value,
        "AssignedTo": assginedToID.value,
        "Status": status.value,
        "DueDate": publishDate.value, // ✅ FIXED
        "IsActive": isActive.value,
      };

      print("update task body $body");

      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/UpdatedTask?id=$id";

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        // await GetAllTask(id);
        // Tasklist.refresh();
        await GetTaskGroup();
        taskGrouplist.refresh(); // ✅ force Obx to rebuild

        taskGrouplist.refresh();

        // final task = Inprogresslist.firstWhere(
        //       (e) => e.taskID == id,
        // );
        // Get.to(() => TaskDetailsUI(
        //   taskModel: task,
        //   CreateBy: task.assignedBy ?? '',
        // ));
        Get.back(result: true);
        Get.snackbar(
          "Success",
          "Task Updated Successfully",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        print("Response ${res.body}");
      } else if (res.statusCode == 401) {
        bool success = await refreshApi();
        if (success) {
          await updateTaskApi(id: id); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        Get.snackbar("Error", res.body.toString());
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }

  TasKmodelDetilsRes tasKmodelDetilsRes = TasKmodelDetilsRes();
  Future<void> GetTaskDetails(int id) async {
    try {
      isloading.value = true;
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/TaskDetails?id=$id";
      print(url);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"authcode": box.read("AppCode")}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final taskdetils = data["taskModelDetails"];

        for (var element in taskdetils) {
          TaskModelDetails taskModel = TaskModelDetails();

          taskModel.taskTitle = element["TaskTitle"];
          taskModel.taskDescription = element["TaskDescription"];
          taskModel.groupName = element["GroupName"];
          taskModel.assignedTo = element["AssignedTo"];
          taskModel.assignedBy = element["AssignedBy"];
          taskModel.taskType = element["TaskType"];
          taskModel.priority = element["Priority"];
          taskModel.statusName = element["Priority"];
          taskModel.dueDate = element["DueDate"];

          tasKmodelDetilsRes.taskModelDetails = taskModel;

          print(taskModel.taskTitle);
        }
      } else {
        print("eror");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
