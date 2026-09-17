import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/bulider/AttendencedetailsBulider.dart';
import 'package:hrapp/features/attendance/controllers/Attendencedetails%20controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Attendencescreen extends StatelessWidget {
  const Attendencescreen({super.key});

  @override
  Widget build(BuildContext context) {
    Attendencedetailscontroller attendencedetailscontroller =
        Get.put(Attendencedetailscontroller());

    Future<void> _selectMonthYear(BuildContext context) async {
      final DateTime? pickedDate = await showMonthPicker(
        context: context,
        initialDate: attendencedetailscontroller.selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null &&
          pickedDate != attendencedetailscontroller.selectedDate) {
        attendencedetailscontroller.selectedDate = pickedDate;
        print(
            "Selected Year: ${attendencedetailscontroller.selectedDate.year}");
        print(
            "Selected Month: ${attendencedetailscontroller.selectedDate.month}");
      }
    }

    DateTime selectedDate = DateTime.now();
    void _pickMonthYear(BuildContext context) async {
      final DateTime? picked = await showMonthPicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null && picked != selectedDate) {
        // Update your selectedDate here
        // Example using setState:
        // setState(() {
        //   selectedDate = picked;
        // });

        // Or, if using a controller (like with GetX):
        // selectedDateController.value = picked;

        debugPrint('Selected Date: ${picked.year}-${picked.month}');
      }
    }

    return Scaffold(
      // backgroundColor: Colors.black12,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Attendence Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        elevation: 5,
        excludeHeaderSemantics: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Row containing the dropdown and calendar button
            Row(
              children: [
                Expanded(
                  child: DropDownTextField(
                    enableSearch: true,
                    clearIconProperty: IconProperty(color: Colors.green),
                    searchTextStyle: const TextStyle(color: Colors.red),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please enter your leave type";
                      }
                      return null;
                    },
                    controller: attendencedetailscontroller.cnt,
                    dropDownItemCount: 12,
                    dropDownList: const [
                      DropDownValueModel(name: "January", value: 1),
                      DropDownValueModel(name: "February", value: 2),
                      DropDownValueModel(name: "March", value: 3),
                      DropDownValueModel(name: "April", value: 4),
                      DropDownValueModel(name: "May", value: 5),
                      DropDownValueModel(name: "June", value: 6),
                      DropDownValueModel(name: "July", value: 7),
                      DropDownValueModel(name: "August", value: 8),
                      DropDownValueModel(name: "September", value: 9),
                      DropDownValueModel(name: "October", value: 10),
                      DropDownValueModel(name: "November", value: 11),
                      DropDownValueModel(name: "December", value: 12),
                    ],
                    textFieldDecoration: const InputDecoration(
                      hintText: "Select a Month",
                    ),
                    onChanged: (val) {
                      print("Selected month: ${val.value}");

                      attendencedetailscontroller.monthTypeId =
                          attendencedetailscontroller.cnt.dropDownValue!.value;

                      // attendencedetailscontroller.cnt.dropDownValue = val;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _selectMonthYear(context);
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),

//             Row(children: [

// TextFormField(decoration:  ,)

//             ],),

            const SizedBox(height: 16),

            attendencedetailscontroller.loading.value
                ? CircularProgressIndicator()
                :

                // Search button
                ElevatedButton(
                    onPressed: () {
                      if (attendencedetailscontroller.monthTypeId == null) {
                        Get.snackbar("Month", "choose any month");
                      } else {
                        attendencedetailscontroller.GetAttendencedetails();
                      }
                    },
                    child: const Text("Search"),
                  ),

            const SizedBox(height: 16),

            // Attendance details card
            attendencedetailscontroller.showCalender
                ? Center(
                    child: Text("please choose month"),
                  )
                : Expanded(
                    child: Card(
                      color: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Sun"),
                                Text("Mon"),
                                Text("Tue"),
                                Text("Wed"),
                                Text("Thu"),
                                Text("Fri"),
                                Text("Sat"),
                              ],
                            ),
                          ),
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: const Attendencedetailsbulider(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
