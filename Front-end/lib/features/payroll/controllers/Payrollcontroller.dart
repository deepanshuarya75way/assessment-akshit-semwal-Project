import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/core/network/CheckInternetConnection.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final Logincontroller loginController = Get.find<Logincontroller>();
final networkCtrl = Get.find<NetworkController>();

class Payrollcontroller extends GetxController {
  String year;

  Payrollcontroller(this.year);

  @override
  void onInit() {
    Getpayroll();

    ever(networkCtrl.isConnected, (bool connected) {
      if (connected) {
        Getpayroll();
      }
    });
    super.onInit();
  }

  var payrolllist = <Payrollmodel>[].obs;

  TextEditingController monthController = TextEditingController();

  var currentMonthPayroll = 0.obs; // not use this variable
  var currentYearPayroll = 0.obs;

  PayrollReponse payrollReponse = PayrollReponse();
  RxBool isloading = false.obs;

  Future<void> Getpayroll() async {
    print(currentMonthPayroll.value); // example:
    isloading.value = true;

    try {
      int? empid = loginController.box.read("UserId");

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/payroll?authcode=${loginController.box.read('AppCode')}&month=$currentMonthPayroll&year=$year";

      final response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      });

      if (response.statusCode == 200) {
        payrolllist.clear();

        print(year);

        final data = jsonDecode(response.body);

        payrollReponse.iserror = data["iserror"];
        payrollReponse.errorMsg = data["errorMsg"];

        final List pay = data["SalarySlip"];

        for (int i = 0; i < pay.length; i++) {
          Payrollmodel payrollmodel = Payrollmodel();

          payrollmodel.id = pay[i]["id"];
          payrollmodel.Empid = pay[i]["EmpId"];
          payrollmodel.empname = pay[i]["EmpName"];
          payrollmodel.dmonth = pay[i]["D_Month"];
          payrollmodel.processingYear = pay[i]["ProcessingYear"];
          payrollmodel.netSalary = pay[i]["NetSalary"];
          payrollmodel.payslipfile = pay[i]["payslipfile"];
          payrollmodel.dateofjion = pay[i]["dateofjion"];
          payrollmodel.currencyCode = pay[i]["currencyCode"];
          payrollmodel.Link = pay[i]["CompanyLink"];
          payrollmodel.PAyYear = pay[i]["PAyYear"];

          // ✅ Create a new list for each payroll entry
          List<payrollDetail> detailsList = [];

          final payroll1 = pay[i]["payrollDetail"];
          for (int j = 0; j < payroll1.length; j++) {
            payrollDetail payrolldetail = payrollDetail();

            payrolldetail.paytype = payroll1[j]["Paytype"];
            payrolldetail.amount = payroll1[j]["Amount"];
            payrolldetail.isallowance = payroll1[j]["isallowance"];

            detailsList.add(payrolldetail);
          }

          payrollmodel.payrolldetails = detailsList;

          payrolllist.add(payrollmodel);
          print("Payroll ID: ${payrollmodel.id}");
        }
      } else if (response.statusCode == 401) {
        bool success = await refreshApi();

        if (success) {
          await Getpayroll(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {
        print("Failed to load payroll: ${response.statusCode}");
      }
    } catch (ex) {
      print("Error: $ex");
    }

    isloading.value = false;
  }
}
