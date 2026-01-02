import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fundamental_flutter_project/l10n/app_localization.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUndo;
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final language = AppLocalizations.of(context)!;
    return Slidable(
      key: ValueKey(transaction.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blue,
            icon: Icons.edit,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) {
              onDelete();
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(language.transactionDeleted),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: language.undo,
                    onPressed: onUndo
                  ),
                )
              );
            },
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            radius: 22.5,
            backgroundColor: transaction.category.backgroundColor,
            child: Image.asset(transaction.category.icon, width: 25, height: 25,),
          ),
          title: Text(transaction.title, style: textTheme.titleLarge),
          trailing: Text("${(transaction.type == TransactionType.income)? "+":"-"} \$${NumberFormat("#,##0.00").format(transaction.amount)}"  , style: textTheme.titleLarge?.copyWith(color: transaction.type.color)),
        ),
      )
    );
  }
}