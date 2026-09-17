class Loginmodel {
  String? email;
  String? password;

  Loginmodel({this.email, this.password});

  Map<String, dynamic> toJson() => {
        'Email_work': email,
        'Password': password,
      };
}

class LoginmodelReponse {
  bool? iserror;
  String? errormsg;

  UserData? userData;

  LoginmodelReponse({this.iserror, this.errormsg, this.userData});
}

class UserData {
  int? id;
  String? propic;
  String? gender;
  int? empCode;
  String? empName;
  String? nationality;
  String? department;
  String? designation;
  String? UserCurency;
  bool? isactive;

  bool? AccessHRMS;

  UserData(
      {this.id,
      this.propic,
      this.gender,
      this.empCode,
      this.empName,
      this.nationality,
      this.department,
      this.designation,
      this.UserCurency});
}
