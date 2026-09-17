import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';

class Table1 extends StatelessWidget {
  const Table1({super.key, required this.payrollmodel});

  final Payrollmodel payrollmodel;

  @override
  Widget build(BuildContext context) {
    final payrollList = payrollmodel.payrolldetails!
        .where((e) => e.isallowance == true)
        .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          /// Top Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Palette.KmainLight1.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "Earnings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                /// Table Header
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Basic Salary",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15,
                //       ),
                //     ),
                //     Text(
                //       "Amount",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15,
                //       ),
                //     ),
                //   ],
                // ),

                /// Empty State
                if (payrollList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No allowances available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )

                /// Data List
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payrollList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, i) {
                      final item = payrollList[i];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.paytype ?? "",
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            "${item.amount}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
