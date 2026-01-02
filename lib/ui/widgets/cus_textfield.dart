import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final String prefix;
  final bool islength;
  final bool isNumInput;
  final TextEditingController text;
  final String? Function(String?)? validator;
  const CustomTextField ({super.key, required this.label, required this.hintText, required this.text, this.prefix = "", this.islength = false, required this.validator, this.isNumInput = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.black),),
        SizedBox(height: 10),
        TextFormField(
          validator: validator,
          controller: text,
          maxLength: islength ? 50 : null,
          keyboardType: isNumInput ? TextInputType.number : null,
          decoration: InputDecoration(
            prefixText: prefix,
            prefixStyle: TextStyle(color: Colors.black),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            isDense: true,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 0, 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2F7E79), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2F7E79), width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF2F7E79), width: 2),
            ),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
