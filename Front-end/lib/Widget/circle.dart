import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/Themecolor/Palette.dart';

class BlackcircleWid extends StatelessWidget {
  BlackcircleWid({super.key, required this.text, required this.color});

  final String? text;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47.h,
      width: 47.w,
      decoration: BoxDecoration(
          color: color, border: Border.all(color: Colors.grey.shade300)),
      child: Center(
        child: Text(text!,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );

    // return CircleAvatar(

    //     radius: 15,
    //     backgroundColor: Colors.black,
    //     child: CircleAvatar(
    //       radius: 14,
    //       backgroundColor: color,
    //       child: Text(
    //         "$text",
    //         style: TextStyle(fontSize: 15, color: Colors.black),
    //       ),
    //     )

    //     );
  }
}
