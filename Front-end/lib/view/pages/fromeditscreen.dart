import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:hrapp/features/leave/controllers/updatedleavecontroller.dart';

import 'package:intl/intl.dart';

class Fromeditscreen extends StatelessWidget {
  const Fromeditscreen({super.key, required this.allleavemodel});

  final Allleavemodel allleavemodel;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    Updatedleavecontroller updatedleavecontroller =
        Get.put(Updatedleavecontroller());

    void fromsubmit() async {
      if (_formkey.currentState!.validate()) {
        Get.snackbar(
          'Success', 'Leave  successfully  Updated',

          snackPosition: SnackPosition.top, // Position of the snackbar
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Get.to(() => ApprovedPage2());
      } else {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      ;
    }

    updatedleavecontroller.Getdayscal();

    String date = allleavemodel.fromDate.toString();
    DateTime dateTime = DateTime.parse(date);

    String fromdate = DateFormat('d MMM yyyy').format(dateTime);

    String date1 = allleavemodel.fromDate.toString();
    DateTime dateTime1 = DateTime.parse(date1);

    String todate = DateFormat('d MMM yyyy').format(dateTime1);

    updatedleavecontroller.Getdayscal();
    // updatedleavecontroller.fromdatecontroller.text = fromdate;
    // updatedleavecontroller.todatecontroller.text = todate;
    // updatedleavecontroller.Leavesdays.text = allleavemodel.Leavedays.toString();
    updatedleavecontroller.remarkcontroller.text =
        allleavemodel.Remarks.toString();

    String txtDate = DateFormat('d MMM yyyy').format(DateTime.now());
    void _fromDate() async {
      final now = DateTime.now();
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now, //get today's date
          firstDate: DateTime
              .now(), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));

      if (pickedDate != null) {
        print(pickedDate);
        DateFormat('yyyy-MM-dd');

        //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('d MMM yyyy').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        print(
            formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need
        txtDate = formattedDate;

        updatedleavecontroller.fromdatecontroller.text = txtDate;

        print(updatedleavecontroller.fromdatecontroller.text);

        // setState(() {
        //   fromdate.text = txtDate;

        //   //set foratted date to TextField value.
        // });
      } else {
        print("Date is not selected");
      }
    }

    void _toDate() async {
      final now = DateTime.now();

      // final firstdate = DateTime(now.year - 1, now.month, now.day);
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now, //get today's date
          firstDate: DateTime
              .now(), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2050));

      if (pickedDate != null) {
        print(
            pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('d MMM yyyy').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        print(
            formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need

        // txtDate = formattedDate;

        updatedleavecontroller.todatecontroller.text = formattedDate;

        print(updatedleavecontroller.fromdatecontroller.text);

        // Addfulldayleave.todatecontroller.text = formattedDate;
        // setState(() {
        //   todate.text = formattedDate;
        //   daysCalModel.fromdate = fromdate.text;
        //   daysCalModel.todate = todate.text;
        // });

        // DaysCalResponson daysCalResponson =
        //     await dayService.postdaycount(daysCalModel);
        // setState(() {
        //   //set foratted date to TextField value.

        //   leaveday.text = daysCalResponson.dayscalculate.toString();
        // });
      } else {
        print("Date is not selected");
      }
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey,
        title: Text("FormEditScreen"),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap: _fromDate,
                          controller: updatedleavecontroller.fromdatecontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            label: const Text("From date"),
                          ),
                          validator: (Value) {
                            if (Value == null || Value.isEmpty) {
                              return "Please enter the date";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextFormField(
                          onTap: _toDate,
                          controller: updatedleavecontroller.todatecontroller,
                          // controller: Addfulldayleave.todatecontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            label: const Text("To date"),
                          ),
                          validator: (Value) {
                            if (Value == null || Value.isEmpty) {
                              return "Please enter to date";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {},
                    // controller: Addfulldayleave.Leavesdays,
                    controller: updatedleavecontroller.Leavesdays,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      label: const Text("Leave Days"),
                    ),
                  ),
                ),
                // Expanded(
                //     child: TextButton(
                //         onPressed: () {
                //           Addfulldayleave.Getdayscal();
                //         },
                //         child: Text("Get")))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            DropDownTextField(
              enableSearch: true,
              clearIconProperty: IconProperty(color: Colors.green),
              searchTextStyle: const TextStyle(color: Colors.red),
              validator: (value) {
                if (value!.isEmpty) {
                  return "please enter your leave type ";
                } else {
                  return null;
                }
              },
              // controller: Addfulldayleave.cnt,
              dropDownItemCount: 13,
              dropDownList: const [
                DropDownValueModel(name: "Annual Leave", value: 1),
                DropDownValueModel(name: "Sick", value: 2),
                DropDownValueModel(name: "Sick Leave Half Pay", value: 4),
                DropDownValueModel(name: "Unpaid Leave", value: 10004),
                DropDownValueModel(
                    name: "Sick Leave Without Pay", value: 20013),
                DropDownValueModel(name: "Half Day Leave", value: 40015),
                DropDownValueModel(name: "Covid Leave", value: 20005),
                DropDownValueModel(name: "Bereavement Leave", value: 20008),
                DropDownValueModel(name: "Marriage Leave", value: 20011),
                DropDownValueModel(name: "Maternity Leave", value: 20012),
                DropDownValueModel(name: "Emergency Leave", value: 30015),
                DropDownValueModel(name: "Hajj Leave", value: 20014),
                DropDownValueModel(name: "Umrah Leave", value: 20015)
              ],
              // clearOption: true,
              textFieldDecoration: InputDecoration(
                hintText: "Select an option",
              ),
              onChanged: (val) {
                // Addfulldayleave.Leavestype =
                //     Addfulldayleave.cnt.dropDownValue!.value;

                // print(Addfulldayleave.Leavestype =
                //     Addfulldayleave.cnt.dropDownValue!.value);

                // int? leaveid = _cnt.dropDownValue!.value;
                // leaverequest.cnt.dropDownValue = val;
                // leaverequest.cnt.dropDownValue = val;

                // print(leaverequest.cnt.dropDownValue);

                // Handle the selected value
                // print(_cnt.dropDownValue!.value);
                // leaveTypeId = _cnt.dropDownValue!.value;
                //   leavetypecon.text = val;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: updatedleavecontroller.remarkcontroller,
              // controller: Addfulldayleave.remarkcontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                label: const Text("remarks"),
              ),
              validator: (Value) {
                if (Value == null || Value.isEmpty) {
                  return "Please enter the your remarks";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    // leaverequestmodel.wFStatus =
                    //     Addfulldayleave.WFStatuscontroller.text = "P";

                    // Addfulldayleave.ishalfday = false;
                    // Addfulldayleave.issubmit = true;
                    // Addfulldayleave.Postleaverequest(leaverequestmodel);

                    // fromsubmit(leaverequestmodel);

                    updatedleavecontroller.Updatedleave(allleavemodel.id);

                    fromsubmit();

                    print("1");
                  },
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width * 0.4,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
