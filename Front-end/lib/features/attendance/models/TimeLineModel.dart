class Timelinemodel {
  int? Approval_Details_ID;
  int? ScreenID;
  int? RecordID;
  int? Approver_ID;
  String? Approver_User_Name;
  String? Approval_Status;
}

class TimelineModelReponse {
  bool? isError;
  String? errorMsg;

  Timelinemodel? TimeLine;
}
