import 'package:flutter/material.dart';
import '../../l10n/app_localization.dart';
import '../../models/category.dart';
import 'package:intl/intl.dart';

class CategoryBudgetGoal extends StatelessWidget {
  final String amountLabel;
  final Category category;
  final double goal;
  final double spent;

  const CategoryBudgetGoal({
    super.key,
    required this.amountLabel,
    required this.category,
    required this.goal,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 22.5,
                backgroundColor:spent>goal? Colors.red : category.backgroundColor,
                child: spent>goal ? 
                  Icon(Icons.error_outline, color: colorTheme.onPrimary,)
                  :
                  Image.asset(
                    category.icon,
                    width: 25,
                    height: 25,
                  ),
                ),
              title: Text(
                "${category.getLabel(language)}${spent>goal ? " : Over Budget !!!" : ""}",
                style: textTheme.titleLarge?.copyWith(
                  color: spent>goal ? Colors.red: colorTheme.onSurface
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "$amountLabel${NumberFormat("#,##0").format(goal)}",
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: spent > goal ? Colors.red : Colors.blue,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "- $amountLabel${NumberFormat("#,##0").format(spent)}",
              textAlign: TextAlign.end,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}