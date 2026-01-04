import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/utils/animations_util.dart';
import '../../models/category.dart';
import '../widgets/calender_statistic.dart';
import '../widgets/cus_month_switcher.dart';
import '../widgets/cus_week_switcher.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/header.dart';
import '../widgets/dashboard_amount.dart';
import '../widgets/transaction_bar_chart.dart';
import '../../l10n/app_localization.dart';
import 'inspect_category.dart';
import 'inspect_statistic.dart';
import 'transaction_form.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';
enum Filter{
  month,
  week
}

class StatisticScreen extends StatefulWidget {
  final User user;
  const StatisticScreen({super.key, required this.user});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  Filter filter = Filter.week;
  DateTime focusedDay = DateTime.now();
  DateTime startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7));
  late List<Transaction> transactions;

  DateTime get start => filter == Filter.month ? DateTime(focusedDay.year, focusedDay.month, 1) : startOfWeek;
  DateTime get end => filter == Filter.month ? DateTime(focusedDay.year, focusedDay.month + 1, 0) : startOfWeek.add(Duration(days: 6));
  double get totalIncome => transactions.fold(0.0, (sum, t) => sum + (t.isIncome ? t.amount : 0));
  double get totalExpense => transactions.fold(0.0, (sum, t) => sum + (t.isExpense ? t.amount : 0));
  String get amountLabel => widget.user.preferredAmountType == AmountType.dollar ? "\$" : "៛";

  @override
  void initState(){
    transactions = widget.user.getTransactionsDuration(start: start, end: end);
    super.initState();
  }

  void onCreate() async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      AnimationUtils.scaleWithFade(TransactionFormScreen(amountLabel: amountLabel,))
    );
    if(newTransaction != null){
      await widget.user.addTransaction(newTransaction);
      setState(() {
        transactions.add(newTransaction);
      });
    }
  }

  void onBack(){
    setState(() {
      focusedDay = DateTime(focusedDay.year, focusedDay.month - 1);
      transactions = widget.user.getTransactionsDuration(start: start, end: end);
    });                  
  }

    void onNext(){
    setState(() {
      focusedDay = DateTime(focusedDay.year, focusedDay.month + 1);
      transactions = widget.user.getTransactionsDuration(start: start, end: end);
    });                  
  }

  void onNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
      transactions = widget.user.getTransactionsDuration(start: start, end: end);
    });
  }

  void onPrevWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
      transactions = widget.user.getTransactionsDuration(start: start, end: end);
    });
  }

  void onTapStatistic(DateTime initialDate, TransactionType? type) async{
    bool? isChanged = await Navigator.of(context).push(
      AnimationUtils.slideTBWithFade(InspectStatistic(user: widget.user,initialDate: initialDate, type: type,))
    );
    if(isChanged == true){
      setState(() {
        transactions = widget.user.getTransactionsDuration(start: start, end: end);
      });
    }
  }

  void onTapCategory(Category category, List<Transaction> list, TransactionType type) async{
    bool? isChanged = await Navigator.push<bool>(
      context,
      AnimationUtils.slideTBWithFade(
        InspectCategory(
          user: widget.user,
          category: category,
          transactions: list,
          type: type,
        ),
      )
    );
    if(isChanged == true){
      setState(() {
        transactions = widget.user.getTransactionsDuration(start: start, end: end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.secondary,
        title: Text(
          "Smart Finance",
          style: textTheme.displayMedium?.copyWith(color: colorTheme.onPrimary),
        ),
      ),
      backgroundColor: colorTheme.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Header(
                greeting: widget.user.getLocalizedGreeting(language),
                userName: widget.user.name,
                onPress: onCreate,
                profileLabel: widget.user.getProfileLabel(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: colorTheme.onPrimary,
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      filter == Filter.month ? 
                        CustomMonthSwitcher(onBack:onBack, date: focusedDay, onNext:onNext) : 
                        CustomWeekSwitcher(onNext: onNextWeek, onBack: onPrevWeek, startDay: startOfWeek),
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<Filter>(
                          initialValue: Filter.week,
                          icon: Icon(Icons.keyboard_arrow_down),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          items: [
                            ...Filter.values.map((f) => DropdownMenuItem(
                              value: f,
                              child: Text(f == Filter.month ? language.month : language.week),
                            ))
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                filter = value;
                                transactions = widget.user.getTransactionsDuration(start: start, end: end);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  DashboardAmount(income: totalIncome, expense: totalExpense, amountLabel: amountLabel),
                  const SizedBox(height: 25),
                  filter == Filter.month?
                    CalenderStatistic(
                      transactionsMonth: transactions, 
                      date: focusedDay, 
                      onPageChange: (focusedDay) {
                        setState(() {
                          focusedDay = focusedDay; 
                        });
                      }, 
                      onTapStatistic:(date) => onTapStatistic(date, null), 
                      amountLabel: amountLabel
                    ) 
                    : 
                    WeeklyBarChart(
                      transactionsWeek: transactions, 
                      startDayofWeek: startOfWeek, 
                      onTapStatistic: (date, type)=> onTapStatistic(date, type),
                      amountLabel: amountLabel,
                    ),
                  const SizedBox(height: 20),
                  CategoryPieChart(transactions: transactions, onTapCategory: onTapCategory, amountLabel: amountLabel,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}




