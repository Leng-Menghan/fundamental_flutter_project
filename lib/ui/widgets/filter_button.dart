import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onPress;
  final bool isClick;
  final String name;
  const FilterButton({super.key, required this.name, required this.onPress, required this.isClick});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: onPress,
      style: TextButton.styleFrom(
        backgroundColor:  isClick? colorTheme.onPrimary:colorTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        )
      ), 
      child: Text(name, style: textTheme.titleLarge?.copyWith(color:isClick? colorTheme.primary : colorTheme.onPrimary))
    );
  }
}