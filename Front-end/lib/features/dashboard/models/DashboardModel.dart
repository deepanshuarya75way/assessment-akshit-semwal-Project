import 'dart:typed_data';

class Dashboardmodel {
  bool? isError;
  String? errorMsg;
  bool? markatt;

  List<LeaveDataModel>? leavedata;

  List<UpcomingActivites>? upcomingactivies;

  List<UpcomingBrithday>? upcomingbrithday;

  GetTime? getime;
}

class LeaveDataModel {
  int? id;
  String? empname;
  String? leavetypes;

  // int? leavedata;

  int? leavedays;

  int? leavebf;
  int? daystaken;
  double? balance;
}

class TotalTaskmdoel {
  int? total;
  String? statusName;
}

class UpcomingActivites {
  int? id;
  String? title;
  String? meassage;
  String? date;
  String? edate;
  String? createdBy;
}

class UpcomingBrithday {
  int? empcode;

  String? empname;
  String? emailwork;
  String? dob;
  Uint8List? imageBytes;

  String? userimage;
}

class GetTime {
  int? AttendenceId;
  String? signin;
  String? signout;
}
