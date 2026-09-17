import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/constants/constants.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:show_hide_password/show_hide_password.dart';

class Loginpage1 extends StatelessWidget {
  const Loginpage1({super.key});

  @override
  Widget build(BuildContext context) {
    final Login = Get.put(Logincontroller());
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Center(
                child: Image.asset(
                  "assets/Main_Logo-removebg-preview.png",
                  height: 100,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontFamily: 'Poppins-Medium',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            endIndent: 22,
                            indent: 22,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: Login.EmailController,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54)),
                                  hintText: "Email ",
                                  hintStyle: TextStyle(color: hintText)),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            width: MediaQuery.of(context).size.width,
                            child: ShowHidePassword(
                              passwordField: (hidePassword) {
                                return TextFormField(
                                  controller: Login.PasswordController,
                                  obscureText:
                                      hidePassword, // Controls password visibility
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54),
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: hintText),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Login.login.value
                                  ? CircularProgressIndicator()
                                  : MaterialButton(
                                      splashColor: Colors.black,
                                      onPressed: () {
                                        if (Login
                                                .EmailController.text.isEmpty ||
                                            Login.PasswordController.text
                                                .isEmpty) {
                                          Get.snackbar("Error",
                                              "Please fill in all fields.");
                                          return;
                                        }

                                        Login.PostLogin();
                                      },
                                      color: Colors.blue,
                                      child: const Center(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                            ],
                          )
                        ],
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
