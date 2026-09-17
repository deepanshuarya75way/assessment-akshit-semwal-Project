import 'package:flutter/material.dart';
import 'package:hrapp/bulider/actvities.dart';

import 'package:hrapp/bulider/brithdaywid.dart';
import 'package:hrapp/bulider/textwid.dart';

import 'package:hrapp/constants/constants.dart';
import 'package:hrapp/constants/Loading_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDay = TimeOfDay.now();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Background2,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              ListTile(
                                title: Text(
                                  "HI",
                                  style: TextStyle(color: Colors.white),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images.png"),
                                  backgroundColor: Colors.blue,
                                  radius: 50,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images.png"),
                                    radius: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: MediaQuery.of(context).size.height * 0.10,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1.29,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          Center(
                            child: Container(
                              height: 200,
                              width: 300,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  topRight: Radius.circular(30),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Icon(
                                    Icons.watch_later_outlined,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "TIME",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    timeOfDay.format(context),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Divider(
                                    endIndent: 50,
                                    thickness: 2,
                                    indent: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: 96,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: signInBox,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "IN",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: 96,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: signInBox,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "OUT",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Wish them",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22,
                                    fontFamily: 'Poppins-Medium',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            child: BirthdayWidget(),
                          ),
                          SizedBox(height: 50),
                          Row(
                            children: [Text("Upcoming Activities")],
                          ),
                          SizedBox(height: 100, child: Activities()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
