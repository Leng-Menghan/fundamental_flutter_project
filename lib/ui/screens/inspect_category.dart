import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart';
import '../../models/user.dart';
import '../../utils/animations_util.dart';
import '../widgets/transaction_item.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import 'transaction_form.dart';

class InspectCategory extends StatefulWidget {
  final User user;
  final Category category;
  final TransactionType type;
  final List<Transaction> transactions;

  const InspectCategory({
    super.key,
    required this.user,
    required this.category,
    required this.transactions,
    required this.type
  });

  @override
  State<InspectCategory> createState() => _InspectCategoryState();
}

class _InspectCategoryState extends State<InspectCategory> {
  bool isChanged = false;
  
  List<Transaction> get transactionsByCategory {
    final list = widget.transactions
        .where((tx) => tx.category == widget.category)
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get totalAmount => transactionsByCategory.fold(0, (sum, tx) => sum + tx.amount);

  void onEdit(Transaction t) async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.slideBTWithFade(TransactionFormScreen(editTransaction: t, amountLabel: amountLabel,))
    );
    if(newTransaction != null){
      await widget.user.updateTransaction(newTransaction, t.id);
      int index = widget.transactions.indexWhere((tx) => tx.id == t.id);
      widget.transactions[index] = newTransaction;
      setState(() {
        isChanged = true;
      });
    }
  }

  void onDelete(String id) async{
    await widget.user.removeTransaction(id);
    widget.transactions.removeWhere((t) => t.id == id);
    setState(() {
      isChanged = true;
    });
  }

  void onUndo(int index, Transaction t) async{
    await widget.user.addTransaction(t);
    widget.transactions.insert(index, t);
    setState(() {
      isChanged = true;
    });
  }
  String get amountLabel => widget.user.preferredAmountType == AmountType.dollar ? "\$" : "៛";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final language = AppLocalizations.of(context)!;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(onPressed: () => Navigator.pop<bool>(context, isChanged) , icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)),
        title: Text(
          "Category Overview",
          style: textTheme.displaySmall?.copyWith(color: colors.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: colors.secondary,
      ),
      backgroundColor: colors.secondary,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: colors.onPrimary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: widget.category.backgroundColor,
                  child: Image.asset(widget.category.icon, width: 30, height: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category.getLabel(language), style: textTheme.displaySmall),
                    Text("${widget.type == TransactionType.income ? "+" : "-"}$amountLabel ${NumberFormat("#,##0.00").format(totalAmount)}", style: textTheme.titleLarge?.copyWith(color: widget.type == TransactionType.income ? Colors.green : Colors.red)),
                  ],
                ),
              ],
            ),
            Expanded(
              child: transactionsByCategory.isEmpty
                  ? Center(
                      child: Text(
                        "No transactions found",
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: transactionsByCategory.length,
                      itemBuilder: (context, index) {
                        final tx = transactionsByCategory[index];
                        final bool showDateHeader =
                          index == 0 ||
                          !isSameDay(
                            tx.date,
                            transactionsByCategory[index - 1].date,
                          );
                        return Column(
                          children: [
                            if (showDateHeader) Padding(
                              padding: const EdgeInsets.only(
                                top: 16,
                                bottom: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 20),
                                  Text(
                                    DateFormat('EEE, MMMM d yyyy').format(tx.date),
                                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            TransactionItem(
                              transaction: tx, 
                              onEdit: () => onEdit(tx), 
                              onDelete: () => onDelete(tx.id),
                              onUndo: () => onUndo(index, tx), 
                              amountLabel: amountLabel,
                            )
                          ],
                        );
                      },
                    ),
            ),
          ]
        ),)
      );
  }
}

/// Helper
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
