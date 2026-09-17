import 'package:hrapp/features/task/models/TaskModel.dart';

class TaskGroup {
  int? groupId;
  String? groupName;
  String? description;
  int? createdBy;
  int? status;

  bool? groupIsavtive;
  DateTime? createdDate;
  bool? isActive;
  List<TaskModelDetails> pendingTasks = [];
  List<TaskModelDetails> completedTasks = [];
  List<TaskModelDetails> overdueTasks = [];
  List<TaskModelDetails> inProgressTasks = [];
  List<TaskModelDetails> inActiveTasks = [];
}

class TaskModel {
  int? taskId;
  String? GroupName;
  String? taskType;
  String? taskStatus;
  String? TaskTypeName;

  String? taskTitle;
  String? taskDescription;
  int? groupId;
  int? assignedTo;
  String? assignedBy;
  String? priority;
  int? status;
  String? dueDate;
  String? createdDate;
  String? updatedDate;
  bool? isActive;
  // int? taskType;
}
