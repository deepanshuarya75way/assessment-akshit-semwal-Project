import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';

class Deduction extends StatelessWidget {
  const Deduction({super.key, required this.payrollmodel});

  final Payrollmodel payrollmodel;

  @override
  Widget build(BuildContext context) {
    final payrollList = payrollmodel.payrolldetails!
        .where((e) => e.isallowance == false)
        .toList();

    return payrollList.isEmpty
        ? SizedBox.shrink()
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Palette.KmainLight1.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Deductions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                /// Empty State
                if (payrollList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "No deductions available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )

                /// List
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payrollList.length,
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (context, index) {
                      final item = payrollList[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.paytype ?? "",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              " ${item.amount}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
  }
}
