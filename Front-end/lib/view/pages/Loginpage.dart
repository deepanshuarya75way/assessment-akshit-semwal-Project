import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/features/authentication/widgets/layer1.dart';
import 'package:hrapp/features/authentication/widgets/layer2.dart';
import 'package:hrapp/features/authentication/widgets/layer3.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assests/primaryBg.png"),
        )),
        child: Stack(
          children: [
            Positioned(
                top: 220,
                left: 59,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
            Positioned(top: 300, left: 1, child: Layer1()),
            Positioned(top: 320, left: 20, child: Layer2()),
            Positioned(top: 400, left: 30, child: Layer3()),
          ],
        ),
      ),
    );
  }
}
