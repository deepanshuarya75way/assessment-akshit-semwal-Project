import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/task/models/Comment.model.dart';
import 'package:hrapp/features/task/models/TaskModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;

class CommentController extends GetxController {
  TextEditingController ADDComment = TextEditingController();

  final commentTextController = TextEditingController();
  var isSending = false.obs;

  Future<void> addComment(String text, int id) async {
    try {
      isSending.value = true;

      const url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/CommentTask';

      Map<String, dynamic> body = {
        "taskID": id,
        "authcode": box.read("AppCode"),
        "commentText": commentTextController.text,
        "commentBy": box.read("UserId"),
        "commentDate": DateTime.now().toIso8601String(),
      };
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        commentTextController.clear();

        Get.snackbar(
          "Success",
          "Comment added",
          snackPosition: SnackPosition.bottom,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );

        await ShowComment(id); // 🔄 refresh list
      } else {
        Get.snackbar("Error", "Failed to add comment");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSending.value = false;
    }
  }
  var isloading = false.obs;

  Future<void> AddComment(int id) async {
    try {
      const url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/CommentTask';

      Map<String, dynamic> body = {
        "taskID": id,
        "authcode": box.read("AppCode"),
        "commentText": ADDComment.text,
        "commentBy": box.read("UserId"),
        "commentDate": DateTime.now().toIso8601String(),
      };

      print(body);

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // <-- important
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        print(data);

        final iserror = data["isError"];

        if (iserror == false) {
          print("success");
          Get.snackbar("Sucess", 
          "Comment added successfully",
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(12),
            duration: Duration(seconds: 2),
          
          
          );
        } else {
          print("error");
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  var commentlist = <CommentModel>[].obs;

  Future<void> ShowComment(int id) async {
    isloading.value = true;
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/GetAllCommentTask?id=$id";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"Authcode": box.read("AppCode")}),
      );

      if (res.statusCode == 200) {
        commentlist.clear();
        final data = jsonDecode(res.body);
        print(data);

        final comment = data["commentModelsList"];

        if (comment != null) {
          for (var element in comment) {
            CommentModel commentModel = CommentModel();

            commentModel.commenename = element["CommentText"];
            commentModel.commentdate = element["CommentDate"];

            commentlist.add(commentModel);
          }

          print(commentlist.length.toString());
          print("sucess");
        } else {
          print("error");
          commentlist.value = [];
        }
      }
    } catch (ex) {
      print(ex);
    } finally {
      isloading.value = false;
    }
  }

  var Pendinglist = <TaskModelDetails>[].obs;
  var comlist = <TaskModelDetails>[].obs;
  var overduelist = <TaskModelDetails>[].obs;

  var pendingMap = <int, List<TaskModelDetails>>{}.obs;
  var completedMap = <int, List<TaskModelDetails>>{}.obs;
  var overdueMap = <int, List<TaskModelDetails>>{}.obs;

  RxInt Penconut = 0.obs;
  RxInt Overdueconut = 0.obs;

  Future<void> Alltaskmodel(int id) async {
    try {
      final url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/TaskPending?id=$id";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"Authcode": box.read("AppCode")}),
      );

      if (res.statusCode == 200) {
        print("API CALLED");
        final data = jsonDecode(res.body);
        comlist.clear();

        final taskList = data["taskPendingList"];
        final ComList = data["ComList"];
        final ovderDue = data["OverDueResList"];

        // ✅ Pending
        List<TaskModelDetails> pending = [];
        if (taskList != null) {
          for (var item in taskList) {
            TaskModelDetails taskModel = TaskModelDetails();
            taskModel.taskTitle = item["TaskTitle"];
            pending.add(taskModel);
          }
        }
        pendingMap[id] = pending;
        pendingMap.refresh(); // 🔥 IMPORTANT

        // ✅ Completed
        List<TaskModelDetails> completed = [];
        if (ComList != null) {
          for (var item in ComList) {
            TaskModelDetails taskModel = TaskModelDetails();
            taskModel.taskTitle = item["TaskTitle"];
            completed.add(taskModel);
            comlist.add(taskModel);
          }
        }
        completedMap[id] = completed;
        completedMap.refresh();

        // ✅ Overdue
        List<TaskModelDetails> overdue = [];
        if (ovderDue != null) {
          for (var item in ovderDue) {
            TaskModelDetails taskModel = TaskModelDetails();
            taskModel.taskTitle = item["TaskTitle"];
            overdue.add(taskModel);
          }
        }
        overdueMap[id] = overdue;
        overdueMap.refresh(); // 🔥 MUST

        print("API CALLED");

        overdueMap.refresh();
        print("API CALLED");

        print("Group $id loaded");
      }

      print("success");
    } catch (ex) {
      print(ex);
    }
  }
}
