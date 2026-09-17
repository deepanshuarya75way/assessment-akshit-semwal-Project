import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hrapp/features/payroll/models/PayrollModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/Widget/Salarywid.dart';
import 'package:hrapp/Widget/deduction.dart';
import 'package:hrapp/Widget/table1.dart';

import 'package:hrapp/constants/constants.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:intl/intl.dart';

import 'package:number_to_words_english/number_to_words_english.dart';

class Salaryslip extends StatelessWidget {
  const Salaryslip({super.key, required this.payrollmodel});

  final Payrollmodel payrollmodel;

  @override
  Widget build(BuildContext context) {
    int? number = payrollmodel.netSalary;
    final currecycode = profilecontroller.profilemodel.Usercurency;
    String? words;
    DateTime parsedDate = DateTime.parse(payrollmodel.PAyYear.toString());

    String PayRollDate = DateFormat('dd MMM yyyy').format(parsedDate);

    // DateTime parsedDate =
    //     DateFormat("dd-MMM-yyyy").parse(payrollmodel.PAyYear.toString());

    // String PayRollDate = DateFormat('dd MMM yyyy').format(parsedDate);

    if (number != null) {
      words = NumberToWordsEnglish.convert(number);
      print(words); // Output: Eight hundred twenty-four
    } else {}

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.KmainLight1.withOpacity(0.15),
          title: Text(
            "Salary Slip",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevation: 5,
          excludeHeaderSemantics: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10)),
                  child: Salarywid(
                    payrollmodel: payrollmodel,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Divider(),
                // Row(
                //   children: [
                //     Text(
                //       "Earning",
                //       style: TextStyle(color: Colors.black, fontSize: 15),
                //     )
                //   ],
                // ),
                Table1(
                  payrollmodel: payrollmodel,
                ),

                SizedBox(
                  height: 15.h,
                ),

                Deduction(
                  payrollmodel: payrollmodel,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.2,
                        color: Colors.blueGrey.shade200,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Net Salary  •  $currecycode ${payrollmodel.netSalary}.000",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        thickness: 1.2,
                        color: Colors.blueGrey.shade200,
                      ),
                    ),
                  ],
                ),
                //////
                ///
                SizedBox(
                  height: 10.h,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "In Words:",
                    //   style: GoogleFonts.aBeeZee(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.grey.shade700,
                    //   ),
                    // ),
                    const SizedBox(width: 6),
                    Center(
                      child: Text(
                        "(${words?.toUpperCase()} $currecycode)",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4, // better line spacing
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: payrollmodel.Link ?? "",
                      fit: BoxFit.contain,

                      /// loading
                      placeholder: (context, url) => const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),

                      /// error
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Prepared by",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "HR Department",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Center(
                      child: Text(
                        "$PayRollDate",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
