import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';
import 'package:hrapp/view/payrollwidget.dart/payrollwid.dart';

class PayrollBuilder extends StatelessWidget {
  const PayrollBuilder({super.key, required this.Year});

  final String Year;

  @override
  Widget build(BuildContext context) {
    print("build");

    print(Year);

    // Initialize the controller only once
    final Payrollcontroller payrollController =
        Get.put(Payrollcontroller(Year));

    final filterlist = payrollController.payrolllist
        .where((payroll) => payroll.processingYear.toString() == Year)
        .toList();

    print(filterlist.length);

    {
      if (filterlist.isEmpty) {
        return const Center(
            child: Text("No Payroll found")); // Loading indicator
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: filterlist.length,
        itemBuilder: (context, index) {
          final payrollDetails = filterlist[index];
          return Payrollwid(
            Year: Year,
            payrollmodel: payrollDetails,
          ); // Pass data to Payrollwid widget
        },
      );
    }
  }
}
