class Attendencedetails {
  int? atn_year;
  int? atn_month;
  int? WEekNumber;
  String? EmpshortName;
  int? empcode;
  String? sun_atn;
  String? mon_atn;
  String? tue_atn;
  String? wed_atn;
  String? thu_atn;
  String? fri_atn;
  String? sat_atn;

  Attendencedetails(
      {this.atn_year,
      this.atn_month,
      this.WEekNumber,
      this.EmpshortName,
      this.empcode,
      this.sun_atn,
      this.mon_atn,
      this.tue_atn,
      this.wed_atn,
      this.thu_atn,
      this.fri_atn,
      this.sat_atn});
}

class AttendenceReponse {
  bool? iserror;
  String? iserrormsg;
  List<Attendencedetails>? attendencedetails;
}
