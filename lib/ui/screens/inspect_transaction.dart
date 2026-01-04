import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localization.dart';
import '../../models/transaction.dart';

class InspectTransaction extends StatelessWidget {
  final String amountLabel;
  final Transaction transaction;
  const InspectTransaction({super.key, required this.amountLabel,required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.secondary,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: colors.secondary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: colors.onPrimary),
        ),
        title: Text(
          "Overview Transaction",
          style: textTheme.displaySmall?.copyWith(color: colors.onPrimary),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: transaction.category.backgroundColor,
                  child: Image.asset(transaction.category.icon, width: 30, height: 30),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.title, style: textTheme.displaySmall),
                      Text(
                        transaction.isExpense ? "Expense" : "Income",
                        style: textTheme.titleMedium?.copyWith(
                          color: transaction.isExpense ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildRow(
              context,
              label: "Category",
              value: transaction.category.getLabel(language),
            ),
            const SizedBox(height: 10),
            _buildRow(
              context,
              label: "Amount",
              value:
                  "${transaction.isExpense ? '-' : '+'}$amountLabel${NumberFormat("#,##0.00").format(transaction.amount)}",
              valueColor: transaction.isExpense ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 10),
            _buildRow(
              context,
              label: "Date",
              value: DateFormat('EEE, dd MMM yyyy').format(transaction.date),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.titleLarge?.copyWith(color: Colors.grey)),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
