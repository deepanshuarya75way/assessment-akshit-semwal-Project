import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/profile/controllers/countusController.dart';
import 'package:hrapp/view/Auth_Screen/ThankYou_screen.dart';
// import 'package:hrapp/Login/Thank_you_screen.dart';
// import 'package:hrapp/controller/ContactUsController.dart';

class Contactusscreen extends StatelessWidget {
  const Contactusscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Contactuscontroller contactuscontroller = Get.put(Contactuscontroller());
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Text("Company Details", style: TextStyle(fontSize: 20)),
                  TextField(
                      controller: contactuscontroller.name,
                      decoration: InputDecoration(labelText: "Full Name")),
                  TextField(
                      controller: contactuscontroller.company,
                      decoration: InputDecoration(labelText: "Company Name")),
                  TextField(
                      controller: contactuscontroller.email,
                      decoration: InputDecoration(labelText: "Work Email")),
                  TextField(
                      controller: contactuscontroller.phone,
                      decoration: InputDecoration(labelText: "Phone Number")),
                  TextField(
                      controller: contactuscontroller.message,
                      decoration:
                          InputDecoration(labelText: "Message (Optional)")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (contactuscontroller.name.text.isEmpty &&
                          contactuscontroller.company.text.isEmpty &&
                          contactuscontroller.email.text.isEmpty &&
                          contactuscontroller.phone.text.isEmpty &&
                          contactuscontroller.message.text.isEmpty) {
                        Get.snackbar("Error", "Please fill all the fields");
                        return;
                      }

                      Get.to(() => ThankYouScreen());

                      contactuscontroller.name.clear();
                      contactuscontroller.company.clear();
                      contactuscontroller.email.clear();
                      contactuscontroller.phone.clear();
                      contactuscontroller.message.clear();
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
