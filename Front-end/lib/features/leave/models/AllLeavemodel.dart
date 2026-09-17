class Allleavemodel {
  int? id;
  String? fromDate;
  String? todate;
  String? requiredDocument;
  String? Leavedays;
  String? wfstatus;
  String? Remarks;
  int? LeaveType;
  String? Leave;
  int? LeaveId;
  bool? ishalfday;
  bool? issumbit;
}

class AllLeaveReponse {
  bool? isError;
  String? errorMsg;
  List<Allleavemodel>? allleave;

  AllLeaveRequest? allLeaveRequest;
}

class AllLeaveRequest {
  List<Allleavemodel>? approved;
  List<Allleavemodel>? pendding;
  List<Allleavemodel>? reject;
}
