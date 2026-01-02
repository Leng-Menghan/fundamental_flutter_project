import 'package:flutter/material.dart';

InputDecoration customInputDecoration() {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:const BorderSide(
        color: Colors.grey, 
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:const BorderSide(color: Color(0xFF2F7E79), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:const BorderSide(color: Color(0xFF2F7E79), width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:const BorderSide(color: Color(0xFF2F7E79), width: 2),
    ),
    contentPadding:const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  );
}