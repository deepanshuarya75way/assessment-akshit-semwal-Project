import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:intl/intl.dart';
import 'package:confetti/confetti.dart'; // Add this import

class BirthdayWidget extends StatelessWidget {
  const BirthdayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dashboardcontroller());

    final today = DateTime.now();

    return Obx(() {
      if (controller.brithdayslist.isEmpty) {
        return _buildEmptyState();
      }

      return Container(
        height: 105, // Increased height for better spacing
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.brithdayslist.length,
          itemBuilder: (context, index) {
            final emp = controller.brithdayslist[index];
            debugPrint("emp ${emp.userimage}");

            final dateTime = DateTime.parse(emp.dob.toString());
            final isToday =
                dateTime.month == today.month && dateTime.day == today.day;
            final formattedDate = DateFormat('d MMM').format(dateTime);
            final name = _getFormattedName(emp.empname);

            return _BirthdayCard(
              name: name,
              date: formattedDate,
              imageBytes: emp.imageBytes,
              userimage: emp.userimage,
              isToday: isToday,
              age: _calculateAge(dateTime),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        height: 160,
        alignment: Alignment.center,
        child: Text(
          "No upcoming birthdays",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getFormattedName(String? fullName) {
    if (fullName == null) return "Employee";
    final nameParts = fullName.split(' ');
    return nameParts.length > 1
        ? '${nameParts[0]} ${nameParts[1][0]}.'
        : fullName;
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class _BirthdayCard extends StatefulWidget {
  final String name;
  final String date;
  final Uint8List? imageBytes;
  final bool isToday;
  final String? userimage;
  final int age;

  const _BirthdayCard({
    required this.name,
    required this.date,
    this.imageBytes,
    this.isToday = false,
    required this.age,
    this.userimage,
  });

  @override
  State<_BirthdayCard> createState() => _BirthdayCardState();
}

class _BirthdayCardState extends State<_BirthdayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    if (widget.isToday) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti effect for today's birthday
          if (widget.isToday)
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 15,
              gravity: 0.1,
            ),

          // Birthday card content
          ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with decoration
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade200,
                        Colors.pink.shade200,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.userimage != null &&
                                widget.userimage!.isNotEmpty
                            ? "${Rs_hrms_config.imageLink}/${widget.userimage}"
                            : "",

                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,

                        // ✅ Smooth fade
                        fadeInDuration: const Duration(milliseconds: 200),

                        // ✅ Loading UI (no layout shift)
                        placeholder: (context, url) => const SizedBox(
                          width: 64,
                          height: 64,
                          child: Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),

                        // ✅ Error fallback avatar
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.grey,
                        ),

                        // ✅ Memory optimization
                        memCacheWidth: 120,
                        memCacheHeight: 120,

                        // ✅ Avoid reload
                        cacheKey: widget.userimage,
                      ),
                    ),
                  ),
                ),

                // Name and age
                Column(
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   '${widget.age} yrs',
                    //   style: TextStyle(
                    //     fontSize: 10,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),`
                  ],
                ),

                // Date with highlight

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isToday
                        ? Colors.red.shade50
                        : Palette.KmainLight2.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isToday ? Colors.red : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Celebration icon for today
                if (widget.isToday)
                  const Icon(
                    Icons.celebration,
                    color: Colors.amber,
                    size: 15,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
