import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardBudgetGoal extends StatelessWidget {
  final String amountLabel;
  final double goal;
  final double spent;
  const DashboardBudgetGoal({super.key, required this.amountLabel, required this.goal, required this.spent});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    double remain = goal - spent;
    return Card(
      color: colorTheme.primary,
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(
                          value: (goal == 0 && spent == 0) ? 0 : (spent > goal) ? 100 : spent / goal ,
                          color: Colors.red,
                          radius: 15,
                          showTitle: false,
                          borderSide: BorderSide(color: Colors.white, width: 3)
                        ),
                        PieChartSectionData(
                          value: (goal == 0 && spent == 0) ? 100 : (spent > goal) ? 0 : remain / goal,
                          color: Colors.blue,
                          radius: 15,
                          showTitle: false,
                          borderSide: BorderSide(color: Colors.white, width: 3)
                        ),
                      ],
                    ),
                  ),
                  goal == 0 ? 
                    Text("No Goal", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary))
                    :
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(spent > goal ? "Over" : "Remain", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
                        Text("$amountLabel ${NumberFormat("#,##0").format(remain)}", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
                      ],
                    )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_circle_down_rounded, color: colorTheme.onPrimary.withAlpha(180)),
                        Text(" Total Goal", style: textTheme.titleLarge?.copyWith(color: colorTheme.onPrimary.withAlpha(180))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("$amountLabel ${NumberFormat("#,##0.00").format(goal)}", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_circle_up_rounded, color: colorTheme.onPrimary.withAlpha(180)),
                        Text(" Total Spent", style: textTheme.titleLarge?.copyWith(color: colorTheme.onPrimary.withAlpha(180))),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("$amountLabel ${NumberFormat("#,##0.00").format(spent)}", style: textTheme.headlineLarge?.copyWith(color: colorTheme.onPrimary)),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}