import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fundamental_flutter_project/ui/screens/inspect_category.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart';
import '../../models/transaction.dart';

class WeeklyBarChart extends StatelessWidget {
  final String amountLabel;
  final List<Transaction> transactionsWeek;
  final DateTime startDayofWeek;
  final Function(DateTime, TransactionType) onTapStatistic;

  const WeeklyBarChart({
    super.key,
    required this.amountLabel,
    required this.transactionsWeek,
    required this.startDayofWeek,
    required this.onTapStatistic
  });

  double getMaxY(List<double> income, List<double> expense) {
    final allValues = [...income, ...expense];
    final maxValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 0;
    return maxValue * 1.2;
  }

  double getInterval(List<double> income, List<double> expense) {
    final allValues = [...income, ...expense];
    double min = allValues.reduce((a, b) => a < b ? a : b);
    double max = allValues.reduce((a, b) => a > b ? a : b);
    double interval = (max-min)/5;
    return interval.ceilToDouble();
  }

  List<DateTime> get week => List.generate(7, (i) => startDayofWeek.add(Duration(days: i)));
  List<double> get weekIncome => week.map((d) => transactionsWeek.fold(0.0, (sum, t) => sum + (isSameDay(d, t.date) && t.isIncome ? t.amount : 0))).toList();
  List<double> get weekExpense => week.map((d) => transactionsWeek.fold(0.0, (sum, t) => sum + (isSameDay(d, t.date) && t.isExpense ? t.amount : 0))).toList();
  double get interval => getInterval(weekIncome, weekExpense);

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    if (weekIncome.every((v) => v == 0) && weekExpense.every((v) => v == 0)) {
      return SizedBox(
        height: 350, 
        child: Center(
          child: Text(
            language.nodata,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent && response?.spot != null) {
                      final indexDate = response!.spot!.touchedBarGroupIndex;
                      final indexType = response.spot!.touchedRodDataIndex; 
                      TransactionType type = indexType == 0 ? TransactionType.income : TransactionType.expense;
                      onTapStatistic(week[indexDate], type);
                    }
                  },
                ),
                maxY: interval * 6,
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 6,
                    barRods: [
                      BarChartRodData(
                        toY: weekIncome[index],
                        width: 10,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: weekExpense[index],
                        width: 10,
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) =>
                          Text("${NumberFormat.compact().format(value).toString()}$amountLabel"),
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final days = [language.sun, language.mon, language.tue, language.wed, language.thu, language.fri, language.sat];
                        int index = value.toInt();
                        if (index < 0 || index >= days.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(days[index]),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= week.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            week[index].day.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(y: 0, color: Colors.grey, strokeWidth: 1, dashArray: [5, 5]),
                    HorizontalLine(y: interval * 6, color: Colors.grey, strokeWidth: 1, dashArray: [5, 5]),
                  ],
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          )
        )
      ]
    );
  }
}