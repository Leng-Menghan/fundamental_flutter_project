import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String greeting;
  final String userName;
  final VoidCallback onPress;
  final String profileLabel;
  const Header({super.key, required this.greeting, required this.userName, required this.onPress, required this.profileLabel});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(child: Text(profileLabel, style: textTheme.headlineMedium)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: textTheme.titleMedium?.copyWith(color: colorTheme.onPrimary)),
                Text(userName, style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary))
              ],
            ),
          ],
        ),
        IconButton(onPressed: onPress, icon: Icon(Icons.add_box_rounded, color: Colors.white, size: 40,),)
      ],
    );
  }
}