import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart'; 

class DashboardAmount extends StatelessWidget {
  final String amountLabel;
  final double total;
  final double income;
  final double expense;
  final bool isTotalExist;
  const DashboardAmount({super.key, required this.amountLabel, this.total = 0, required this.income, required this.expense, this.isTotalExist = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Card(
      color: colorTheme.primary,
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isTotalExist ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.totalBalance, style: textTheme.titleLarge?.copyWith(color: colorTheme.onPrimary)),
                const SizedBox(height: 5),
                Text("$amountLabel ${NumberFormat("#,##0.00").format(total)}", style: textTheme.displayLarge?.copyWith(color: colorTheme.onPrimary)),
                const SizedBox(height: 20),
              ],
            ) : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_circle_down_rounded, color: colorTheme.onPrimary.withAlpha(180)),
                    Text(" ${AppLocalizations.of(context)!.income}", style: textTheme.titleLarge?.copyWith(color: colorTheme.onPrimary.withAlpha(180))),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.arrow_circle_up_rounded, color: colorTheme.onPrimary.withAlpha(180)),
                    Text(" ${AppLocalizations.of(context)!.expense}", style: textTheme.titleLarge?.copyWith(color: colorTheme.onPrimary.withAlpha(180))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$amountLabel ${NumberFormat("#,##0.00").format(income)}", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
                Text("$amountLabel ${NumberFormat("#,##0.00").format(expense)}", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
              ],
            )
          ],
        ),
      )
    );
  }
}