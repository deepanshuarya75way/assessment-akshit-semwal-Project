import 'package:flutter/material.dart';
import 'package:hrapp/constants/constants.dart';

class Layer2 extends StatelessWidget {
  const Layer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 584,
      decoration: BoxDecoration(
          color: layerTwoBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
            bottomLeft: Radius.circular(60.0),
          )),
    );
  }
}
