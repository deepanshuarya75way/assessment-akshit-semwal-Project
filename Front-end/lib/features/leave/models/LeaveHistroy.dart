class Leavehistroy {
  int? id;
  String? fromDate;
  String? todate;
  String? requiredDocument;
  int? Leavedays;
  String? wfstatus;
  String? Remarks;
  String? LeaveType;
  bool? ishalfday;
  bool? issumbit;
}

class LeaveHistroyReponse {
  bool? iserror;

  AllLeaveHistroy? allLeaveHistroy;
}

class AllLeaveHistroy {
  List<Leavehistroy>? approved;
  List<Leavehistroy>? pendding;
  List<Leavehistroy>? reject;
}
