import 'package:flutter/material.dart';
import 'package:hrapp/Themecolor/Palette.dart';

import 'package:hrapp/view/TimeSheet/DarftTimeSheet.dart';
import 'package:hrapp/view/TimeSheet/SubmittedTimeSheet.dart';

class TimeSheetDetails extends StatelessWidget {
  const TimeSheetDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.KmainLight1.withOpacity(0.15),
          title: Text(
            "TimeSheet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey.shade700,
              labelColor: Palette.KmainDark1,
              indicatorColor: Palette.KmainDark2,
              indicatorWeight: 5.0,
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 8,
              ),
              tabs: [
                Tab(
                  child: Text("Draft"),
                ),
                Tab(
                  child: Text("Submitted"),
                )
              ]),
        ),
        body: TabBarView(children: [Darfttimesheet(), Submittedtimesheet()]),
      ),
    );
  }
}
