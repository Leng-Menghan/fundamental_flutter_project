import 'package:flutter/material.dart';

class CustomeSelectDate extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController text;
  final VoidCallback onTap;
  final String label;
  final String hintText;
  const CustomeSelectDate({super.key, required this.validator, required this.hintText, required this.label, required this.onTap, required this.text});

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
          readOnly: true,
          showCursor: false, 
          enableInteractiveSelection: false,
          onTap: onTap,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.calendar_month, size: 25,),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            isDense: true,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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