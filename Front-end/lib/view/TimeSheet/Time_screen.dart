import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/Help_function.dart';
import 'package:hrapp/common/Reuseable_button.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/timesheet/controllers/GetTimeSheetController.dart';
import 'package:intl/intl.dart';

class Time_Sheet_Screen extends StatefulWidget {
  Time_Sheet_Screen({super.key, required this.TimeId});

  final int? TimeId;

  @override
  State<Time_Sheet_Screen> createState() => _Time_Sheet_ScreenState();
}

class _Time_Sheet_ScreenState extends State<Time_Sheet_Screen> {
  final Gettimesheetcontroller gettimesheetcontroller =
      Get.find<Gettimesheetcontroller>(); // ✔ use find now

  final Dashboardcontroller dashboardcontroller =
      Get.put(Dashboardcontroller());

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      gettimesheetcontroller.FetchTimeSheet(widget.TimeId!); // Auto fetch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: const Text("TimeSheet"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// TOP CARD — Clock Details
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildLabel("Work Date :"),
                        BuildText(
                            DateFormat('dd-MM-yyyy').format(DateTime.now())),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildLabel("Clock IN - Clock OUT:"),
                        BuildText(
                          "${dashboardcontroller.getTime.signin ?? ''} - ${dashboardcontroller.getTime.signout ?? ''}",
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildLabel("Total Hours :"),
                        BuildText(
                          (dashboardcontroller.getTime.signin?.isNotEmpty ??
                                      false) &&
                                  (dashboardcontroller
                                          .getTime.signout?.isNotEmpty ??
                                      false)
                              ? getTotalHours(
                                  dashboardcontroller.getTime.signin!,
                                  dashboardcontroller.getTime.signout!,
                                )
                              : '0 Hrs',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Task Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Add Task Details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),

                                    /// FORM UI INSIDE DIALOG
                                    buildInputField(
                                      label: "Task Name *",
                                      controller:
                                          gettimesheetcontroller.taskcontroller,
                                    ),
                                    divider(),
                                    buildInputField(
                                      keyboardType: TextInputType.number,
                                      label: "Time(In Hours) *",
                                      controller: gettimesheetcontroller
                                          .totalhourcontroller,
                                    ),
                                    divider(),

                                    projectDropdown(
                                        selectedValue: selectedProject,
                                        items: projectList),

                                    divider(),
                                    // buildInputField(
                                    //   label: "Project Code *",
                                    //   controller: gettimesheetcontroller
                                    //       .projectcodecontroller,
                                    // ),

                                    buildInputField(
                                      label: "Notes *",
                                      controller: gettimesheetcontroller
                                          .notescontroller,
                                    ),

                                    const SizedBox(height: 20),

                                    /// SAVE BUTTON
                                    Obx(() {
                                      return gettimesheetcontroller
                                              .isLoading.value
                                          ? const CircularProgressIndicator
                                              .adaptive()
                                          : EditButton(
                                              text: "Save",
                                              icon: Icons.save,
                                              onTap: () async {
                                                if (gettimesheetcontroller
                                                        .taskcontroller
                                                        .text
                                                        .isEmpty ||
                                                    gettimesheetcontroller
                                                        .totalhourcontroller
                                                        .text
                                                        .isEmpty ||
                                                    selectedProject
                                                        .value.isEmpty ||
                                                    gettimesheetcontroller
                                                        .notescontroller
                                                        .text
                                                        .isEmpty) {
                                                  Get.snackbar(
                                                    "Missing Information",
                                                    "Please fill out all required fields.",
                                                    snackPosition:
                                                        SnackPosition.top,
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.8),
                                                    colorText: Colors.white,
                                                  );
                                                  return;
                                                }

                                                /// SAVE DATA
                                                await gettimesheetcontroller
                                                    .PostTimeSheet(
                                                        widget.TimeId!);

                                                /// REFRESH LIST
                                                gettimesheetcontroller
                                                    .FetchTimeSheet(
                                                        widget.TimeId!);

                                                /// CLEAR CONTROLLERS
                                                gettimesheetcontroller
                                                    .taskcontroller
                                                    .clear();
                                                gettimesheetcontroller
                                                    .totalhourcontroller
                                                    .clear();
                                                gettimesheetcontroller
                                                    .projectcodecontroller
                                                    .clear();
                                                gettimesheetcontroller
                                                    .notescontroller
                                                    .clear();

                                                /// CLOSE POPUP

                                                Get.backLegacy(); // 🔥 Close dialog
                                              },
                                            );
                                    }),

                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              const SizedBox(height: 8),
              divider(),
              Obx(() {
                if (gettimesheetcontroller.isFetchLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (gettimesheetcontroller.FeatchtimeSheetList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No TimeSheet Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount:
                        gettimesheetcontroller.FeatchtimeSheetList.length,
                    itemBuilder: (context, index) {
                      final sheet =
                          gettimesheetcontroller.FeatchtimeSheetList[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                gettimesheetcontroller.DeleteTimeSheet(
                                    sheet.id!, sheet.TimesheetId!);
                                // delete logic
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4)
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.task,
                                  size: 28, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sheet.task ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("${sheet.totalHour ?? ''} Hrs"),
                                  ],
                                ),
                              ),
                              Text(sheet.projectCode ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 10),

              Obx(
                () => gettimesheetcontroller.isLoading.value
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : EditButton(
                        text: "Submit",
                        icon: Icons.save,
                        onTap: () {
                          if (gettimesheetcontroller
                              .FeatchtimeSheetList.isEmpty) {
                            Get.snackbar(
                              "TimeSheet is Incomplete",
                              "Please fill out the TimeSheet.",
                              snackPosition: SnackPosition.top,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                            return;
                          }

                          gettimesheetcontroller.SumbitTimeSheet(
                              widget.TimeId!);
                        },
                      ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     gettimesheetcontroller.SumbitTimeSheet(widget.TimeId!);
      //     print("Button Clicked");
      //   },
      //   backgroundColor: Palette.Kmain,
      //   child: const Text(
      //     "Submit",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      // ),
    );
  }

  Widget divider() => const Divider(
        thickness: 1,
        color: Colors.black12,
      );
}
