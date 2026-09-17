import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/constants/constants.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:show_hide_password/show_hide_password.dart';

class Login2 extends StatelessWidget {
  const Login2({super.key});

  @override
  Widget build(BuildContext context) {
    final Login = Get.put(Logincontroller());
    Profilecontroller profilecontroller = Get.put(Profilecontroller());
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50), // Extra spacing at the top
              // Logo section
              Center(
                child: Container(
                  height: 295,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                    "https://res.cloudinary.com/dbi2izwfz/image/upload/v1747047454/4_eapumo.png",
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Welcome text
              // Text(
              //   'Welcome Back!',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.blueGrey[800],
              //   ),
              // ),
              // SizedBox(height: 20),

              // Email input field
              TextFormField(
                controller: Login.EmailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blueGrey[600]),
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Password input field with Show/Hide
              ShowHidePassword(
                passwordField: (hidePassword) {
                  return TextFormField(
                    controller: Login.PasswordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.blueGrey[600]),
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),

              // Login button
              Obx(() => Login.login.value
                  ? Center(child: CircularProgressIndicator())
                  : MaterialButton(
                      onPressed: () {
                        if (Login.EmailController.text.isEmpty ||
                            Login.PasswordController.text.isEmpty) {
                          Get.snackbar("Error", "Please fill in all fields.");
                          return;
                        }

                        Login.PostLogin();
                        profilecontroller.GetProfile();
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),

              // Optional: Forgot password link
              SizedBox(height: 20),
              // Center(
              //   child: TextButton(
              //     onPressed: () {
              //       // Handle forgot password action
              //     },
              //     child: Text(
              //       'Forgot Password?',
              //       style: TextStyle(color: Colors.blueGrey[600]),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
