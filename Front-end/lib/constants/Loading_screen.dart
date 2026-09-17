 
 import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  Widget _box({double height = 20, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            /// Greeting
            _box(height: 16, width: 120),
            const SizedBox(height: 8),
            _box(height: 24, width: 180),

            const SizedBox(height: 24),

            /// Summary Cards Row
            Row(
              children: [
                Expanded(child: _box(height: 100)),
                const SizedBox(width: 12),
                Expanded(child: _box(height: 100)),
              ],
            ),

            const SizedBox(height: 20),

            /// Button
            _box(height: 50),

            const SizedBox(height: 24),

            /// Productivity Title
            _box(height: 18, width: 120),

            const SizedBox(height: 16),

            /// Productivity Cards
            Row(
              children: [
                Expanded(child: _box(height: 90)),
                const SizedBox(width: 12),
                Expanded(child: _box(height: 90)),
              ],
            ),

            const SizedBox(height: 24),

            /// Wish Them Title
            _box(height: 18, width: 100),

            const SizedBox(height: 16),

            /// Avatar Row
            Row(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}