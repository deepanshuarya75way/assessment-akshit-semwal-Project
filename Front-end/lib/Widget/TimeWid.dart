import 'package:flutter/material.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimeWid extends StatelessWidget {
  const TimeWid({super.key, required this.images, required this.text});

  final String images;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 120, // Bounded height to avoid unbounded height error
        child: FixedTimeline(
          children: [
            TimelineTile(
              oppositeContents: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(text), // Replaced 'text' with a sample string
              ),
              node: TimelineNode(
                indicator: ContainerIndicator(
                  size: 20.0,
                  child: Container(
                    width: 20.0, // Adjusted to fit indicator size
                    height: 20.0, // Added height for consistency
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.Ksecondary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0), // Reduced padding
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 8, // Adjusted to fit within Container
                        backgroundImage:
                            NetworkImage(images), // Replaced 'images'
                      ),
                    ),
                  ), // Matches Container size
                ),
                startConnector: const SolidLineConnector(
                  indent: 22,
                  color: Palette.Kmain,
                ),
                endConnector: const SolidLineConnector(
                  color: Palette.Kmain,
                ),
              ),
              // contents: const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text('Event Description'), // Added sample content
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
