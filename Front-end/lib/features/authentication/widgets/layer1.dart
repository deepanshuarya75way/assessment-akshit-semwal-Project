import 'package:flutter/material.dart';
import 'package:hrapp/constants/constants.dart';

class Layer1 extends StatelessWidget {
  const Layer1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 654,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        color: layerOneBg,
      ),
    );
  }
}
