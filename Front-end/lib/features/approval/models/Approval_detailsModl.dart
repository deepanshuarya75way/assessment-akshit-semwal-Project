import 'package:hrapp/features/leave/models/approvalleavemodel.dart';

class ApprovalDetails {
  int? empid;
  int? id;
  String? fromdate;
  String? todate;

  int? leavedays;
  String? remarks;
  String? Wfstatus;
  int? LeaveId;
  String? empname;
  String? leavetype;
  int? month;
  int? year;
  String? screenname;
  String? appdetails;
  int? groupID;
  int? approval_Details_ID;
  int? screenID;

  int? recordID;
  int? approver_ID;

  String? Approver_User_Name;

  int? Approver_Sequence;

  String? Approval_Status;

  String? Status;

  ApprovalLeaveModel? approvalLeaveModel;
  List<ApprovalTimeSheetDetails>? appTimeSheet;
}

class Approval_DetailsResponse {
  bool? isError;
  String? errorMsg;

  List<ApprovalDetails>? approvaldetails;
}
