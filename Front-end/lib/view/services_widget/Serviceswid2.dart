import 'dart:math';

import 'package:flutter/material.dart';

class Serviceswid2 extends StatelessWidget {
  const Serviceswid2(
      {super.key,
      required this.image,
      required this.title,
      this.ontap,
      this.icon,
      this.color,
      this.color1});

  final String image;

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

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(-0.1) // Tilt along X-axis
        ..rotateY(-0.1), // Tilt along Y-axis
      alignment: FractionalOffset.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.30,
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        tileMode: TileMode.mirror,
                        colors: [
                          Colors.purple,
                          Colors.blue,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      // color: getRandomBlueShade(),
                      borderRadius: BorderRadius.circular(30),
                      // image: DecorationImage(
                      //   image: AssetImage(image),
                      //   fit: BoxFit.contain,
                      // )
                    ),
                    child: icon,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    title,
                    style: TextStyle(
                        color: color1 == null ? Colors.black : color1,
                        fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
