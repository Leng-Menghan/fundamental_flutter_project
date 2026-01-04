import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';

class CategoryItem extends StatelessWidget {
  final String amountLabel;
  final Category category;
  final TransactionType type;
  final String percentage;
  final double amount;
  final int transactionCount;
  const CategoryItem({
    super.key,
    required this.amountLabel,
    required this.category,
    required this.type,
    required this.percentage,
    required this.amount,
    required this.transactionCount
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22.5,
        backgroundColor: category.backgroundColor,
        child: Image.asset(
          category.icon,
          width: 25,
          height: 25,
        ),
      ),
      title: Text(category.getLabel(language), style: textTheme.titleLarge?.copyWith(color: colorTheme.onSurface)),
      subtitle: Text(
        percentage,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${(type == TransactionType.income) ? "+" : "-"} $amountLabel${NumberFormat("#,##0.00").format(amount)}",
            style: textTheme.titleLarge?.copyWith(
              color:(type == TransactionType.income) ? Colors.green : Colors.red,
            ),
          ),
          Text(
            "$transactionCount ${language.transaction}",
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}