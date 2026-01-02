import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';

class InspectTransaction extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  final ValueChanged<Transaction> onEdit;
  const InspectTransaction({super.key, required this.transaction, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isExpense = transaction.type == TransactionType.expense;

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
          "Overview",
          style: textTheme.displaySmall?.copyWith(color: colors.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: colors.onPrimary),
            onPressed:() => onEdit(transaction),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: colors.onPrimary),
            onPressed: onDelete
          ),
         SizedBox(width: 8),
        ],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.title, style: textTheme.displaySmall),
                    Text(
                      isExpense ? "Expense" : "Income",
                      style: textTheme.titleMedium?.copyWith(
                        color: isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildRow(
              context,
              label: "Category",
              value: transaction.category.label,
            ),
            const SizedBox(height: 10),
            _buildRow(
              context,
              label: "Amount",
              value:
                  "${isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}",
              valueColor: isExpense ? Colors.red : Colors.green,
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
