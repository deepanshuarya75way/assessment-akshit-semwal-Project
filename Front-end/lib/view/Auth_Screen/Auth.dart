import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/authentication/controllers/Local_AuthController.dart';
import 'package:hrapp/view/navbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalLogin localLogin = Get.put(LocalLogin());

  @override
  void initState() {
    super.initState();
    _autoAuthenticate();
  }

  bool isAuthenticated = false;
  bool isFace = false;

  Future<void> _autoAuthenticate() async {
    final available = await localLogin.auth.getAvailableBiometrics();

    // detect type

    final bool isSuccess = await localLogin.localAuth();

    if (isSuccess) {
      setState(() {
        isAuthenticated = true;
      });
      Get.off(() => Navbar());
    } else {
      Get.snackbar("Failed", "Try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/lottie/auth.json",
                    animate: true,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),

                  // const SizedBox(height: 20),

                  const Text(
                    "Scan Your Biometrics",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Securely verify your identity to unlock",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 30),

                  // manual retry button
                  GestureDetector(
                      onTap: () {
                        _autoAuthenticate();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Palette.KmainDark1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Unlock",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
