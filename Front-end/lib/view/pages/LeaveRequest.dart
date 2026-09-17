import 'package:flutter/material.dart';
import 'package:hrapp/bulider/leavebulider.dart';

class Leaverequest extends StatelessWidget {
  const Leaverequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave Request"),
      ),
      body: Leavebulider1(),
    );
  }
}
