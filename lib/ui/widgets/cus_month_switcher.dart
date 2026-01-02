import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomMonthSwitcher extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isBig;
  final DateTime date;
  const CustomMonthSwitcher({super.key, required this.onNext, required this.onBack, required this.date, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorTheme.primary,
            size: 20,
          ),
        ),
        isBig ? const Spacer() : const SizedBox(),
        SizedBox(width: 150, child: Text(DateFormat.yMMMM(locale).format(date), textAlign: TextAlign.center, style: textTheme.titleLarge?.copyWith(color: colorTheme.onSurface))),
        isBig ? const Spacer() : const SizedBox(),
        GestureDetector(
          onTap: onNext,               
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: colorTheme.primary,
            size: 20,
          ),
        ),
      ],
    );
  }
}