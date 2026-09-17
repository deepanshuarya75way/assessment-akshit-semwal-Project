import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

String getTotalHours(String start, String end) {
  // Example start: "1:00 PM"
  // Example end: "2:00 PM"

  final format = DateFormat("h:mm a");

  final startTime = format.parse(start);
  final endTime = format.parse(end);

  final diff = endTime.difference(startTime);

  return "${diff.inHours} Hours ${diff.inMinutes % 60} Minutes";
}

DateTime now = DateTime.now();
String formattedDate = DateFormat("d MMM yyyy").format(now);

Widget buildLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    ),
  );
}

Widget BuildText(String label) {
  return Text(
    label,
    style: TextStyle(fontSize: 15, color: Colors.grey),
  );
}

var projectList = <String>[
  "RS HRMS",
  "Mada HRMS",
  "RS HRMS DEMO",
  "Esterad Dynamic CRM",
  "Solidarity Bespoke Development",
  "Internal ReadSecure Meeting",
  "External Meeting",
  "Documentation",
  "Mada ERP",
  "Mada Aggregator Web",
  "Mada Aggregator API",
  "Mada Aggregator Mobile",
  "Mada Corporate Aggregator",
  "Mada Corporate Aggregator API",
  "FixAts",
].obs;

Widget buildInputField(
    {required String label,
    String? initialValue,
    bool? enabled,
    bool? readOnly,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Color? fillColor,
    TextEditingController? controller,
    TextInputType? keyboardType}) {
  return Padding(
    padding: padding ?? const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: fillColor ?? Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            keyboardType: keyboardType ?? TextInputType.text,
            controller: controller,
            readOnly: readOnly ?? false,
            enabled: enabled,
            initialValue: initialValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent, // handled by Container
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 14),
                borderSide: const BorderSide(color: Colors.grey, width: 1.4),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

var selectedProject = ''.obs;
Widget projectDropdown({
  required RxString selectedValue,
  required List<String> items,
  double fontSize = 14,
}) {
  return Obx(
    () => DropdownButton<String>(
      value: items.contains(selectedValue.value) ? selectedValue.value : null,
      isExpanded: true,
      hint: const Text("Select Project"),
      items: items.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: fontSize),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) selectedValue.value = value;
      },
    ),
  );
}
