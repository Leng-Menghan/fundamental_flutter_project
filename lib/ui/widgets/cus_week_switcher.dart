import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class CustomWeekSwitcher extends StatelessWidget {
  final DateTime startDay;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CustomWeekSwitcher({
    super.key,
    required this.startDay,
    required this.onNext,
    required this.onBack
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final label =
        "${DateFormat('dd MMM yyyy', locale).format(startDay)}"
        " - "
        "${DateFormat('dd MMM yyyy', locale).format(startDay.add(Duration(days: 6)))}";
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(Icons.arrow_back_ios_rounded,
              color: colorTheme.primary, size: 20),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium,
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: onNext,
          child: Icon(Icons.arrow_forward_ios_rounded,
              color: colorTheme.primary, size: 20),
        ),
      ],
    );
  }
}
