// import 'package:flutter/material.dart';
// import 'package:hrapp/common/ProfileTile.dart';
// import 'package:hrapp/common/drawer.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (context) => IconButton(
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//               icon: Icon(Icons.menu)),
//         ),
//         backgroundColor: Colors.green[400],
//       ),
//       drawer: MyDrawer(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green[500],
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(100),
//                       bottomRight: Radius.circular(100),
//                     ),
//                   ),
//                   height: 200,
//                   width: MediaQuery.of(context).size.width,
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(height: 70),
//                     Center(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 90,
//                             height: 80,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 40,
//                             backgroundColor: Colors.grey[200],
//                             child: Icon(Icons.person,
//                                 size: 50, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 60),
//                     CommonTile(
//                       title: 'Name',
//                       subtitle: 'XYZ',
//                       icon: Icon(Icons.person),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'E-mail',
//                       subtitle: 'XYZ@gmail.com',
//                       icon: Icon(Icons.email),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'Gender',
//                       subtitle: 'Male',
//                       icon: Icon(Icons.male),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'Department',
//                       subtitle: 'XYZ',
//                       icon: Icon(Icons.departure_board),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'Designation',
//                       subtitle: 'XYZ',
//                       icon: Icon(Icons.description),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'CurrentAddress',
//                       subtitle: 'XYZ',
//                       icon: Icon(Icons.location_city),
//                     ),
//                     SizedBox(height: 20),
//                     CommonTile(
//                       title: 'PermanentAddress',
//                       subtitle: 'XYZ',
//                       icon: Icon(Icons.location_city),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
