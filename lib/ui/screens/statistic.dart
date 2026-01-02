import 'package:flutter/material.dart';
import '../widgets/calender_statistic.dart';
import '../widgets/cus_month_switcher.dart';
import '../widgets/cus_week_switcher.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/header.dart';
import '../widgets/dashboard_amount.dart';
import '../widgets/transaction_bar_chart.dart';
import '../../l10n/app_localization.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7));
  Filter filter = Filter.week;

  void isRefresh(){
    setState(() {});
  }

  void onCreate() async {
    Transaction? newTransaction = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormScreen(),
      ),
    );
    if(newTransaction != null){
      await widget.user.addTransaction(newTransaction);
      setState(() {});
    }
  }

  void onBack(){
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });                  
  }

    void onNext(){
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });                  
  }

  void onNextWeek() {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7));
    });
  }

  void onPrevWeek() {
    setState(() {
      startOfWeek = startOfWeek.subtract(Duration(days: 7));
    });
  }
  DateTime get start => filter == Filter.month ? DateTime(_focusedDay.year, _focusedDay.month, 1) : startOfWeek;
  DateTime get end => filter == Filter.month ? DateTime(_focusedDay.year, _focusedDay.month + 1, 0) : startOfWeek.add(Duration(days: 6));
  List<Transaction> get transactions =>  widget.user.getTransactionsDuration(start: start, end: end);
  double get totalIncome => widget.user.getTotalAmountByType(transactionList: transactions, type: TransactionType.income);
  double get totalExpense => widget.user.getTotalAmountByType(transactionList: transactions, type: TransactionType.expense);
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
                        CustomMonthSwitcher(onBack:onBack, date: _focusedDay, onNext:onNext) : 
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
                              child: Text(f.name),
                            ))
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                filter = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  DashboardAmount(income: totalIncome, expense: totalExpense),
                  const SizedBox(height: 25),
                  filter == Filter.month?
                    CalenderStatistic(user: widget.user ,date: _focusedDay, onPageChange: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay; 
                      });
                    }, isRefresh: isRefresh,) 
                    : 
                    WeeklyBarChart(user: widget.user, date: startOfWeek, isRefresh: isRefresh),
                  const SizedBox(height: 20),
                  CategoryPieChart(user: widget.user, start: start, end: end, isRefresh: isRefresh,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}




