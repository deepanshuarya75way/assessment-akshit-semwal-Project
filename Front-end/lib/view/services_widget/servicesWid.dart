import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/ccustomappbar.dart';

class Serviceswid extends StatelessWidget {
  const Serviceswid(
      {super.key,
      this.image,
      required this.title,
      this.ontap,
      this.icon,
      this.color,
      this.color1});

  final String? image;

  final String title;

  final void Function()? ontap;

  final Icon? icon;
  final Color? color;
  final Color? color1;

  @override
  Widget build(BuildContext context) {
    // Color getRandomColor() {
    //   Random random = Random();
    //   return Color.fromARGB(
    //     255, // Opacity (255 means fully opaque)
    //     random.nextInt(256), // Red
    //     random.nextInt(256), // Green
    //     random.nextInt(256), // Blue
    //   )
    // }
    Color getRandomBlueShade() {
      final random = Random();
      int blue = 200 + random.nextInt(56); // Range: 200-255 for a bright blue
      return Color.fromRGBO(0, 0, blue, 1); // Pure blue shades
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 80.h,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey, style: BorderStyle.none),

                // gradient: LinearGradient(
                //   tileMode: TileMode.mirror,
                //   colors: [
                //     Colors.blue,
                //     Color(0xFF0A1D48),
                //   ],
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                // ),

                color: color == null ? Colors.white : color,

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black
                //         .withOpacity(0.5), // Shadow color with opacity
                //     spreadRadius: 1, // Spread radius (how wide the shadow is)
                //     blurRadius: 3, // Blur radius (how soft the shadow is)
                //     offset: Offset(0, 3), // Shadow position (x, y)
                //   ),
                // ]
              ),
              child: InkWell(
                onTap: ontap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        // color: Color(0xFF0A1D48),
                        // gradient: LinearGradient(
                        //   colors:Color(0xFF0A1D48),
                        //   begin: Alignment.topRight,
                        //   end: Alignment.bottomLeft,
                        // ),
                        // color: getRandomBlueShade(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image(
                        image: AssetImage(image!),
                        color: Palette.Kmain,
                        width: 25.w,
                        height: 25.h,
                      ),
                    ),

                    // Text(
                    //   title,
                    //   style: TextStyle(
                    //       color: color1 == null ? Colors.black : color1,
                    //       fontSize: 12),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: color1 == null ? Colors.black : color1,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
