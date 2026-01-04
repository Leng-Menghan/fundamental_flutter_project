import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';
import '../../utils/animations_util.dart';
import '../widgets/header.dart';
import '../widgets/dashboard_amount.dart';
import '../widgets/transaction_filter_button.dart';
import '../widgets/transaction_item.dart';
import '../../l10n/app_localization.dart';
import 'transaction_form.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TransactionType? filter;
  late List<Transaction> transactionsToday;

  @override
  void initState(){
    transactionsToday = widget.user.getTransactionsToday(type: filter);
    super.initState();
  }

  List<Transaction> get transactions => filter == null ? transactionsToday : transactionsToday.where((t) => filter == TransactionType.income ? t.isIncome : t.isExpense).toList();
  double get totalToday => filter == null ? transactions.fold(0.0, (sum, t) => sum + (t.isExpense ? -t.amount : t.amount)) : transactions.fold(0.0, (sum, t) => sum + t.amount);
  String get sign => filter == TransactionType.income ? '+' : filter == TransactionType.expense ? '-' : '';

  double get totalBalance => widget.user.getTotalBalance();
  double get totalIncome => widget.user.getTotalAmountByType(type: TransactionType.income);
  double get totalExpense => widget.user.getTotalAmountByType(type: TransactionType.expense);

  void onCreate() async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.scaleWithFade(
        TransactionFormScreen(amountLabel: amountLabel,)
      ),
    );

    if(newTransaction != null){
      await widget.user.addTransaction(newTransaction);
      setState(() {
        transactionsToday.insert(0, newTransaction);
      });
    }
  }

  void onEdit(Transaction tx) async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.slideBTWithFade(
        TransactionFormScreen(editTransaction: tx, amountLabel: amountLabel)
      ),
    );
    if(newTransaction != null){
      await widget.user.updateTransaction(newTransaction, tx.id);
      setState(() {
        transactionsToday = transactionsToday.map((t) => t.id == tx.id ? newTransaction : t).toList();
      });
    }
  }

  void onDelete(String id) async{
    await widget.user.removeTransaction(id);
    setState(() {
      transactionsToday.removeWhere((t) => t.id == id);
    });
  }

  void onUndo(Transaction t) async{
    await widget.user.addTransaction(t);
    setState(() {
      transactionsToday.insert(0, t);
    });
  }
  String get amountLabel => widget.user.preferredAmountType == AmountType.dollar ? "\$" : "៛";
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;
    final formattedDate = DateFormat("dd MMMM y", Localizations.localeOf(context).toString()).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.secondary,
        title: Text("Smart Finance", style: textTheme.displayMedium?.copyWith(color: colorTheme.onPrimary),),
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -1800,
              right: -1000,
              left: -1000,
              child: Container(
                height: 2000,
                width: 2000,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorTheme.secondary
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(greeting: widget.user.getLocalizedGreeting(language), userName: widget.user.name, onPress: onCreate, profileLabel: widget.user.getProfileLabel(),),
                  const SizedBox(height: 10),
                  DashboardAmount(
                    total: totalBalance, 
                    income: totalIncome,
                    expense: totalExpense, 
                    isTotalExist: true, 
                    amountLabel: amountLabel,
                  ),
                  const SizedBox(height: 30),
                  TransactionFilterButton(
                    isExistAll: true, 
                    onPress: (type){
                      setState(() {
                        filter = type;
                      });
                    }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${language.today} $formattedDate", style: textTheme.titleLarge),
                      Text("$sign $amountLabel${NumberFormat("#,##0.00").format(totalToday)}" , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: filter == null? Colors.blue : filter!.color))
                    ],
                  ),
                  const SizedBox(height: 10),
                  transactions.isNotEmpty ? ListView.builder(
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(), 
                    itemCount: transactions.length,
                    itemBuilder: (context, index){
                      Transaction t = transactions[index];
                      return TransactionItem(
                        transaction: t, 
                        onEdit: () => onEdit(t), 
                        onDelete: () => onDelete(t.id), 
                        onUndo: () => onUndo(t), 
                        amountLabel: amountLabel,
                      );
                    }
                  ) : 
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text("There is no transaction, Today!", style: textTheme.titleMedium?.copyWith(color: colorTheme.onSurface),),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
    ));
  }
}