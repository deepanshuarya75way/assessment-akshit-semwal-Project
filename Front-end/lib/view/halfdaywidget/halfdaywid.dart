import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/Halfdaylistmodel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/ccustomappbar.dart';

import 'package:intl/intl.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

class Halfdaywid extends StatelessWidget {
  const Halfdaywid({super.key, required this.halfdaylistmodel});

  final Halfdaylistmodel halfdaylistmodel;

  @override
  Widget build(BuildContext context) {
    // final halfdaycontroller = Get.find<Halfdaycontroller>();

    // halfdaycontroller.gethalfdaylist();

    String date = halfdaylistmodel.fromdate.toString();
    DateTime dateTime = DateTime.parse(date);

    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

    String month = DateFormat(' MMM ').format(dateTime);

    String date1 = halfdaylistmodel.fromdate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String day = DateFormat(' dd ').format(dateTime1);

    return Column(
      children: [
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    height: 20.h,
                    width: 40.w,
                    decoration: const BoxDecoration(
                        color: Palette.Kmain,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Center(
                      child: Text(
                        month,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                Expanded(
                  child: Container(
                      height: 30.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                              color: Palette.Kmain,
                              fontSize: 12.w,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),

          title: Row(
            children: [
              Text(
                "$formattedDate",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),

          subtitle: Text(
            "${halfdaylistmodel.remarks}",
          ),

          // trailing: Container(
          //   height: 20,
          //   width: 70,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20), color: Colors.green),
          //   child: Align(
          //       alignment: Alignment.center,
          //       child: Text(
          //         "${halfdaylistmodel.wfstatus}",
          //         style: TextStyle(color: Colors.white),
          //       )),
          // ),
        ),
        Divider()
      ],
    );
  }
}
