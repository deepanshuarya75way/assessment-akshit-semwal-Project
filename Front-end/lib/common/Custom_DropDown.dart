import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<DropDownValueModel> items;
  final Function(dynamic) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      
      enableSearch: true,
      clearIconProperty: IconProperty(color: Colors.green),
      searchTextStyle: const TextStyle(color: Colors.red),
      validator: validator,

      dropDownItemCount: items.length,
      dropDownList: items,

      textFieldDecoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),

      onChanged: onChanged,
    );
  }
}