class Payrollmodel {
  int? id;
  int? Empid;
  String? empname;
  int? processingYear;
  String? dmonth;
  int? netSalary;
  String? payslipfile;
  String? dateofjion;
  String? currencyCode;
  String? Link;
  String? PAyYear;

  List<payrollDetail>? payrolldetails;
}

class PayrollReponse {
  bool? iserror;
  String? errorMsg;

  List<Payrollmodel>? payrolllist;
}

class payrollDetail {
  String? paytype;
  double? amount;

  bool? isallowance;
}
