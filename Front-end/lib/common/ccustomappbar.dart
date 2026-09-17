import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/constants/constants.dart';

class Ccustomappbar extends StatelessWidget {
  const Ccustomappbar({super.key});

  @override
  Widget build(BuildContext context) {
    double hieght = 825.h;
    double width = 375.w;
    return Container(
      width: width,
      height: hieght,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Services",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
