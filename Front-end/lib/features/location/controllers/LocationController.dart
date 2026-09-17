// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationController extends GetxController {
//   final RxBool isHome = false.obs;
//   final RxString message = ''.obs;
//   final RxBool isLoading = false.obs;
//   final RxString attendanceMessage = ''.obs;

//   Rx<Position?> currentPosition = Rx<Position?>(null);

//   final double officeLat = 26.215483;
//   final double officeLng = 50.459530;
//   final double radiusMeters = 1000; // For hexagon boundary

//   var markers = <Marker>{}.obs;
//   var polygons = <Polygon>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     setGeofence();
//     checkLocation();
//   }

//   double metersToLatDegrees(double meters) => meters / 111000;
//   double metersToLngDegrees(double meters, double latitude) =>
//       meters / (111000 * cos(latitude * pi / 180));

//   List<LatLng> getHexagonPoints() {
//     final int sides = 6;
//     final List<LatLng> hexPoints = [];

//     for (int i = 0; i < sides; i++) {
//       final double angle = (pi / 3) * i; // 60 degrees per point
//       final double dx = radiusMeters * cos(angle);
//       final double dy = radiusMeters * sin(angle);

//       final double latOffset = metersToLatDegrees(dy);
//       final double lngOffset = metersToLngDegrees(dx, officeLat);

//       hexPoints.add(LatLng(officeLat + latOffset, officeLng + lngOffset));
//     }

//     return hexPoints;
//   }

//   void setGeofence() {
//     List<LatLng> geofencePoints = getHexagonPoints();

//     markers.clear();
//     polygons.clear();

//     // Markers at geofence points
//     markers.addAll(
//       geofencePoints.map((point) {
//         return Marker(
//           markerId: MarkerId(point.toString()),
//           position: point,
//           infoWindow: const InfoWindow(title: "Geofence Point"),
//         );
//       }).toSet(),
//     );

//     // Office center marker
//     markers.add(
//       Marker(
//         markerId: const MarkerId("office"),
//         position: LatLng(officeLat, officeLng),
//         infoWindow: const InfoWindow(title: "Office"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       ),
//     );

//     // Geofence polygon
//     polygons.add(
//       Polygon(
//         polygonId: const PolygonId("geofence"),
//         points: geofencePoints,
//         strokeColor: Colors.orange,
//         strokeWidth: 2,
//         fillColor: Colors.orange.withOpacity(0.3),
//       ),
//     );

//     // Current location marker
//     if (currentPosition.value != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("current_location"),
//           position: LatLng(
//             currentPosition.value!.latitude,
//             currentPosition.value!.longitude,
//           ),
//           infoWindow: const InfoWindow(title: "My Location"),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             BitmapDescriptor.hueGreen,
//           ),
//         ),
//       );
//     }
//   }

//   Future<bool> checkLocation() async {
//     try {
//       isLoading.value = true;

//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         message.value = 'Location services are disabled.';
//         return false;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           message.value = 'Location permission denied.';
//           return false;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         message.value = 'Location permission permanently denied.';
//         return false;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       currentPosition.value = position;

//       // Check if current location is within radius using Haversine
//       double distance = Geolocator.distanceBetween(
//         officeLat,
//         officeLng,
//         position.latitude,
//         position.longitude,
//       );

//       if (distance <= radiusMeters) {
//         isHome.value = true;
//         message.value = 'You are inside the office area.';
//         return true;
//       } else {
//         isHome.value = false;
//         message.value = 'You are NOT inside the office area.';
//         return false;
//       }
//     } catch (e) {
//       message.value = 'Error: $e';
//       return false;
//     } finally {
//       isLoading.value = false;
//       setGeofence(); // Update visuals
//     }
//   }

//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied.');
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     currentPosition.value = position;
//     setGeofence();
//     return position;
//   }
// }
