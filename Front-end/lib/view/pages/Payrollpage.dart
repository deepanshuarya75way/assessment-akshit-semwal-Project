import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/bulider/payrollbulider.dart';
import 'package:hrapp/features/payroll/controllers/Payrollcontroller.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Payrollpage extends StatefulWidget {
  const Payrollpage({super.key});

  @override
  State<Payrollpage> createState() => _PayrollpageState();
}

@override
class _PayrollpageState extends State<Payrollpage> {
  String selectedYear = '2026'; // Default year
  final List<String> years = [
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  @override
  Widget build(BuildContext context) {
    final Payrollcontroller payrollController =
        Get.put(Payrollcontroller(selectedYear));
    // payrollController.Getpayroll();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        centerTitle: true,
        title: const Text(
          "Payroll",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: selectedYear,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: years.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue!;
                });

                payrollController.year = newValue!;
                payrollController.Getpayroll();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          /// 🔥 PAYROLL LIST / LOADING
          Expanded(
            child: Obx(() {
              if (payrollController.isloading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: PayrollBuilder(
                    Year: selectedYear,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// final Payrollcontroller payrollController = Get.put(Payrollcontroller());
// void _pickMonthYear(BuildContext context) async {
//   final picked = await showMonthPicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2020), // allow past years
//     lastDate: DateTime(2100), // allow future years
//   );

//   if (!context.mounted) return; // 🔥 FIX

//   if (picked != null) {
//     payrollController.currentMonthPayroll.value = picked.month;
//     payrollController.currentYearPayroll.value = picked.year;

//     /// 👇 show in UI
//     payrollController.monthController.text =
//         DateFormat('MMMM yyyy').format(picked);

//     /// 👇 IMPORTANT (refresh data)
//     payrollController.Getpayroll();
//   }
// }
