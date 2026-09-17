import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/models/LoginModel.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/view/pages/Salaryslip.dart';

class Payrollwid extends StatelessWidget {
  const Payrollwid({
    super.key,
    required this.payrollmodel,
    required this.Year,
  });

  final Payrollmodel payrollmodel;
  final String Year;

  @override
  Widget build(BuildContext context) {

    final salary = payrollmodel.netSalary ?? 0;

    final currecycode = payrollmodel.currencyCode ?? '';

    return GestureDetector(
      onTap: () {
        Get.to(
          () => Salaryslip(payrollmodel: payrollmodel),
          transition: Transition.cupertino,
          duration: const Duration(milliseconds: 300),
        );

        print({currecycode.toString()});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          children: [
            /// Left Icon Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            /// Middle Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Month
                  Text(
                    payrollmodel.dmonth ?? "Month",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  /// Salary
                  Text(
                    "${currecycode} ${salary}.000",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Small Status Badge
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 10, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: const Text(
                  //     "Paid",
                  //     style: TextStyle(
                  //       color: Colors.green,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            /// Arrow
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
