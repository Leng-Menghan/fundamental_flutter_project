import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fundamental_flutter_project/ui/screens/inspect_statistic.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localization.dart';
import '../../models/transaction.dart';
import '../../models/user.dart';

class WeeklyBarChart extends StatefulWidget {
  final User user;
  final DateTime date;
  final VoidCallback isRefresh;
  const WeeklyBarChart({
    super.key,
    required this.user,
    required this.date,
    required this.isRefresh
  });

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  List<DateTime> getWeekDays(DateTime start) {
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  double getMaxY(List<double> income, List<double> expense) {
    final allValues = [...income, ...expense];
    final maxValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 0;
    return maxValue * 1.2;
  }

  double getInterval(List<double> income, List<double> expense, {int steps = 5}) {
    final allValues = [...income, ...expense];
    final maxValue = allValues.isNotEmpty ? allValues.reduce((a, b) => a > b ? a : b) : 0;
    double interval = (maxValue / steps).ceilToDouble();
    return interval;
  }

  void onTapStatistic(BuildContext context, DateTime initialDate, TransactionType type) async{
    bool? isChanged = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InspectStatistic(user: widget.user,initialDate: initialDate, type: type)
      ),
    );
    if(isChanged == true){
      widget.isRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    List<DateTime> weekDates = getWeekDays(widget.date);
    List<double> weekIncome = widget.user.getWeeklyData(weekDates, TransactionType.income);
    List<double> weekExpense = widget.user.getWeeklyData(weekDates, TransactionType.expense);
    double interval = getInterval(weekIncome, weekExpense);
    double maxY = getMaxY(weekIncome, weekExpense);

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
                      onTapStatistic(context, weekDates[indexDate], type);
                    }
                  },
                ),
                maxY: maxY,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) =>
                          Text(NumberFormat.compact().format(value).toString()),
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
                        if (index < 0 || index >= weekDates.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            weekDates[index].day.toString(),
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
                    HorizontalLine(y: maxY, color: Colors.grey, strokeWidth: 1, dashArray: [5, 5]),
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