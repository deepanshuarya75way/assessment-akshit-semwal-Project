import 'package:flutter/material.dart';
import 'package:hrapp/Themecolor/Palette.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: Palette.Kmain,
            width: 3,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Row(
              children: [
                Icon(
                  Icons.campaign,
                  size: 16,
                  color: Palette.Kmain,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // ElevatedButton.icon(
                //     onPressed: () {
                //       // Get.to(() => Fromeditscreen2(
                //       //       allleavemodel: allleavemodel,
                //       //     ));
                //     },
                //     style: ButtonStyle(
                //         backgroundColor: WidgetStateProperty.all(Colors.green)),
                //     icon: Icon(
                //       Icons.edit,
                //       color: Colors.white,
                //       size: 15,
                //     ),
                //     label: Text(
                //       'Edit',
                //       style: TextStyle(color: Colors.white),
                //     )),
              ],
            ),

            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Your navigation or edit action
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.white), // White background

                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        // <-- Green border
                        color: Palette.Ksecondary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Palette.Kmain, // Green icon to match border
                  size: 15,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    color: Palette.Kmain, // Green text
                  ),
                ),
              ),
            ),

            /// MESSAGE
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            /// DATE
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icon(
                //   Icons.calendar_today_outlined,
                //   size: 12,
                //   color: Palette.primaryBlue,
                // ),
                const SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
