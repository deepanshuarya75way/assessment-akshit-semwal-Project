class Taskmodel {
  int? id;
  String? TaskType;
}

class TaskModelDetails {
  int? taskID;
  int? groupId;
  String? taskTitle;
  String? taskDescription;
  String? groupName;
  String? assignedTo;
  String? assignedBy;
  String? taskType;
  String? statusName;
  String? priority;
  int? status;
  String? dueDate;
  String? createdDate;
  DateTime? updatedDate;
  String? status1;

  int? assignedToId;
}

class TasKmodelDetilsRes {
  TaskModelDetails? taskModelDetails;
}
