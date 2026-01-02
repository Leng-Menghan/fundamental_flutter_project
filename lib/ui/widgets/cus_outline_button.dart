import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String name;
  final bool isLong;
  final VoidCallback onPress;
  const CustomOutlineButton({super.key, required this.name,this.isLong = false, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isLong == true ? double.infinity : 150,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(18),
          side: BorderSide(color: Color(0xFF438883), width: 2),
        ),
        onPressed: onPress,
        child: Text(name, style: TextStyle(fontSize: 16, color: Color(0xFF438883))),
      ),
    );
  }
}