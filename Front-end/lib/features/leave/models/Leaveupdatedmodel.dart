import 'package:flutter/cupertino.dart';

class LeaveUpdatedModel with ChangeNotifier {
  int? empid;
  String? fromdate;
  String? todate;
  int? leavetype;
  int? leavedays;
  String? requireddocument;
  String? wfstatus;
  bool? ishalfday;

  String? remarks;

  bool? issubmit;
  LeaveUpdatedModel({
    this.empid,
    this.fromdate,
    this.todate,
    this.requireddocument,
    this.wfstatus,
    this.leavetype,
    this.remarks,
    this.ishalfday,
    this.issubmit,
    this.leavedays,
  });
}

class LeaveUpdatedResponse {
  bool? isError;
  String? errorMsg;
  bool? updatedscucessfully;
}
