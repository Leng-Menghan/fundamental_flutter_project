import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/ui/screens/inspect_statistic.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';

class CalenderStatistic extends StatefulWidget {
  final User user;
  final DateTime date;
  final ValueChanged<DateTime> onPageChange;
  final VoidCallback isRefresh;
  const CalenderStatistic({super.key, required this.user, required this.date, required this.onPageChange, required this.isRefresh});

  @override
  State<CalenderStatistic> createState() => _CalenderStatisticState();
}

class _CalenderStatisticState extends State<CalenderStatistic> {
  
  void onTapStatistic(DateTime initialDate) async{
    bool? isChanged = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InspectStatistic(user: widget.user,initialDate: initialDate)
      ),
    );
    if(isChanged == true){
      widget.isRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorTheme.primary,
        borderRadius: BorderRadius.circular(20)
      ),
      padding:const EdgeInsets.fromLTRB(5, 5, 5, 20),
      child: TableCalendar(
        locale: Localizations.localeOf(context).languageCode,
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        headerVisible: false,
        rowHeight: 70,
        daysOfWeekHeight: 50,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: textTheme.titleMedium!.copyWith(color: colorTheme.onPrimary),
          weekendStyle: textTheme.titleMedium!.copyWith(color: colorTheme.onPrimary),
        ),
        focusedDay: widget.date,
        onPageChanged: widget.onPageChange,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) => buildDayCell(day, context),
          todayBuilder: (context, day, focusedDay) => buildDayCell(day, context, isToday: true) 
        ),
      ),
    );
  }

  Widget buildDayCell(DateTime date, BuildContext context, {bool isToday = false}) {
    List<Transaction> transactions = widget.user.getTransactions(year: date.year, month: date.month, day: date.day);
    double totalExpense = widget.user.getTotalAmountByType(transactionList: transactions, type: TransactionType.expense);
    double totalIncome = widget.user.getTotalAmountByType(transactionList: transactions, type: TransactionType.income);
    String formatAmount(double amount) => NumberFormat.compact().format(amount);

    return GestureDetector(
      onTap: () => onTapStatistic(date),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin:const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(5),
          color: isToday ? Colors.yellowAccent: Colors.white, 
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text("${date.day}"),
            ),
              Column(
                children: [
                  if(totalIncome != 0) Text("\$${formatAmount(totalIncome)}",style: const TextStyle(fontSize: 8, color: Colors.green)),
                  if(totalExpense != 0) Text("\$${formatAmount(totalExpense)}", style: const TextStyle(fontSize: 8, color: Colors.red)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}