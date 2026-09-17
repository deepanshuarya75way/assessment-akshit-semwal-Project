class Leaverequestmodel {
  int? empid;
  String? fromDate;
  String? todate;
  int? leaveDays;
  String? requiredDocument;
  String? remarks;
  String? wFStatus;
  int? leaveType;
  bool? ishalfday;
  bool? issubmit;
}

class LeaverequestResponson {
  bool? iserror;
  String? errormsg;

  int? id;

  bool? dataadded;
}
