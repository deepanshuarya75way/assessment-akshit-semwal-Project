class Halfdaylistmodel {
  int? id;
  int? empid;
  String? fromdate;
  String? wfstatus;

  String? remarks;
  String? leavetype;

  bool? isHalfDay;

  bool? isSubmit;
}

class Halfdaylistreponse {
  bool? isError;
  String? errorMsg;

  List<Halfdaylistmodel>? halfdaylist;
}
