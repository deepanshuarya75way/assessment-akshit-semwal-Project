import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/constants/constants.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/view/navbar.dart';

class Layer3 extends StatelessWidget {
  const Layer3({super.key});

  @override
  Widget build(BuildContext context) {
    final Login = Get.put(Logincontroller());
    final profile = Get.put(Profilecontroller());

    return Column(
      children: [
        Container(
          height: 600,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 10,
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                  top: 59,
                  left: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: Login.EmailController,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Email ",
                          hintStyle: TextStyle(color: hintText)),
                    ),
                  )),
              Positioned(
                top: 130,
                left: 10,
                child: Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Poppins-Medium',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Positioned(
                  top: 160,
                  left: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: Login.PasswordController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Password ",
                        hintStyle: TextStyle(color: hintText),
                      ),
                    ),
                  )),
              Positioned(
                  top: 250,
                  left: 100,
                  child: Obx(() => Login.login.value
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () {
                            if (Login.EmailController.text.isEmpty ||
                                Login.PasswordController.text.isEmpty) {
                              Get.snackbar(
                                  "Error", "Please fill in all fields.");

                              return;
                            }
                            Login.PostLogin();

                            // if (Login.login.value) {
                            //   Login.PostLogin();
                            // } else {
                            //   CircularProgressIndicator();
                            //   return;
                            // }

                            profile.GetProfile();
                            // Get.snackbar("sucess", 'yes');

                            // Get.to(() => Navbar(), transition: Transition.fadeIn);
                          },
                          child: Container(
                            width: 96,
                            height: 50,
                            decoration: BoxDecoration(
                                color: signInBox,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Poppins-Medium',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ))),
            ],
          ),
        ),
      ],
    );
  }
}
