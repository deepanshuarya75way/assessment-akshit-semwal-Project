class AttendanceRecord {
  int? id;
  int? atnYear;
  int? atnMonth;
  DateTime? atnDate;
  String? atnDay;
  String? isWeekendLeave;
  int? weekNumber;
  String? empCode;
  String? department;
  String? designation;
  String? empName;
  int? empID;
  DateTime? startTime; // Nullable for null StartTime
  String? empShortName;
  String? attnD;
  String? sMonth;
  int? atnDateDay;
  int? wkOrder;

  AttendanceRecord({
    this.id,
    this.atnYear,
    this.atnMonth,
    this.atnDate,
    this.atnDay,
    this.isWeekendLeave,
    this.weekNumber,
    this.empCode,
    this.department,
    this.designation,
    this.empName,
    this.empID,
    this.startTime,
    this.empShortName,
    this.attnD,
    this.sMonth,
    this.atnDateDay,
    this.wkOrder,
  });
}

class Attendencerecordsresponse {
  bool? iserror;
  String? iserrormsg;

  List<AttendanceRecord>? attendencedetails;
}
