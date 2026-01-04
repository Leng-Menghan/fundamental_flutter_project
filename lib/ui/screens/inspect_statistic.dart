import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
import '../../utils/animations_util.dart';
import '../widgets/cus_outline_button.dart';
import '../widgets/transaction_filter_button.dart';
import '../widgets/transaction_item.dart';
import '../../models/transaction.dart';
import 'transaction_form.dart';

class InspectStatistic extends StatefulWidget {
  final User user;
  final DateTime initialDate;
  final TransactionType? type;
  const InspectStatistic({super.key, required this.initialDate, this.type, required this.user});

  @override
  State<InspectStatistic> createState() => _InspectStatisticState();
}

class _InspectStatisticState extends State<InspectStatistic> {
  TransactionType? selectedType;
  late DateTime date;
  bool isChanged = false;

  void onCreate() async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.scaleWithFade(TransactionFormScreen(amountLabel: amountLabel, date: date,))
    );
    if(newTransaction != null){
      await widget.user.addTransaction(newTransaction);
      setState(() {
        isChanged = true;
      });
    }
  }

  @override
  void initState(){
    if(widget.type != null){
      selectedType = widget.type!;
    }else{
      selectedType = TransactionType.income;
    }
    date = widget.initialDate;
    super.initState();
  }

  List<Transaction> get filteredTransactions {
    return widget.user.getTransactions(year: date.year, month: date.month, day: date.day).where((t) {
      return t.type == selectedType;
    }).toList();
  }

  double get total => filteredTransactions.fold(0, (sum, t) => sum + t.amount);
    
  void onNextDay() {
    setState(() {
      date = date.add(Duration(days: 1));
    });
  }

  void onPreDay() {
    setState(() {
      date = date.subtract(Duration(days: 1));
    });
  }

  void onEdit(Transaction t) async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.slideBTWithFade(TransactionFormScreen(editTransaction: t, amountLabel: amountLabel))
    );

    if(newTransaction != null){
      await widget.user.updateTransaction(newTransaction, t.id);
      setState(() {
        isChanged = true;
      });
    }
  }

  void onDelete(String id) async{
    await widget.user.removeTransaction(id);
    setState(() {
      isChanged = true;
    });
  }
  void onUndo(Transaction t) async{
    await widget.user.addTransaction(t);
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
    return Scaffold(
      backgroundColor: colors.secondary,

      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: colors.secondary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, isChanged),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: Text(
          DateFormat('EEE, MMMM d yyyy').format(date),
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: textTheme.titleLarge),
                Text(
                  '$amountLabel${NumberFormat("#,##0.00").format(total)}',
                  style: textTheme.titleLarge?.copyWith(
                    color: selectedType == TransactionType.expense
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TransactionFilterButton(
              currentSelect: selectedType,
              onPress: (type) {
                setState(() => selectedType = type!);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final tx = filteredTransactions[index];
                  return TransactionItem(
                    transaction: tx, 
                    onEdit: () => onEdit(tx), 
                    onDelete: () => onDelete(tx.id),
                    onUndo: () => onUndo(tx), amountLabel: amountLabel,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: onPreDay,
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: colors.primary,
                  ),
                ),
                const Spacer(),
                CustomOutlineButton(name: "Add", onPress: onCreate),
                const Spacer(),
                IconButton(
                  onPressed: onNextDay,
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
