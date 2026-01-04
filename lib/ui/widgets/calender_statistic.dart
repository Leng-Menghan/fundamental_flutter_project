import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/transaction.dart';

class CalenderStatistic extends StatelessWidget {
  final String amountLabel;
  final DateTime date;
  final List<Transaction> transactionsMonth;
  final ValueChanged<DateTime> onPageChange;
  final ValueChanged<DateTime> onTapStatistic;
  const CalenderStatistic({super.key, required this.amountLabel, required this.transactionsMonth, required this.date, required this.onPageChange, required this.onTapStatistic});

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
        focusedDay: date,
        onPageChanged: onPageChange,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) => buildDayCell(day, context),
          todayBuilder: (context, day, focusedDay) => buildDayCell(day, context, isToday: true) 
        ),
      ),
    );
  }

  Widget buildDayCell(DateTime date, BuildContext context, {bool isToday = false}) {
    List<Transaction> transactions = transactionsMonth.where((t) => isSameDay(t.date, date)).toList();
    double totalExpense = transactions.fold(0.0, (sum, t) => sum + (t.isExpense ? t.amount : 0));
    double totalIncome = transactions.fold(0.0, (sum, t) => sum + (t.isIncome ? t.amount : 0));
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
                  if(totalIncome != 0) Text("$amountLabel${formatAmount(totalIncome)}",style: const TextStyle(fontSize: 8, color: Colors.green)),
                  if(totalExpense != 0) Text("$amountLabel${formatAmount(totalExpense)}", style: const TextStyle(fontSize: 8, color: Colors.red)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}