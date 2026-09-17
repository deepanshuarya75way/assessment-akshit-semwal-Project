class Profilemodel {
  int? id;
  int? empcode;
  String? empname;
  String? email_work;
  String? department;
  String? designation;
  String? currentaddress;
  String? permanentaddress;
  String? profilepic;
  String? gender;
  String? image;
  String? userimage;
  String? Usercurency;
  String? DOB;
  String? MobileNo;
}

class ProfileModelReponse {
  bool? iserror;
  String? errmag;

  Profilemodel? profilemodel;
}
