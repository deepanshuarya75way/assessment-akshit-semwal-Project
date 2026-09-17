class Upcomingandpastleavemodel {
  int? id;

  String? FromDate;
  String? ToDate;
  String? RequiredDocument;
  int? Leavedays;
  String? Remarks;
  String? WFStatus;
  int? LeaveId;
  String? LeaveType;
  int? year;
  int? Month;
}

class UpcomingandpastleaveReponse {
  bool? isError;
  String? errorMsg;

  List<Upcomingandpastleavemodel>? upcominglist;

  List<Upcomingandpastleavemodel>? pastlist;
}
