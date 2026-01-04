import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localization.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';
import 'category_item.dart';
import 'transaction_filter_button.dart';

class CategoryPieChart extends StatefulWidget {
  final String amountLabel;
  final List<Transaction> transactions;
  final Function(Category, List<Transaction>, TransactionType) onTapCategory;
  const CategoryPieChart({super.key, required this.amountLabel ,required this.transactions, required this.onTapCategory});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  TransactionType filter = TransactionType.income;

  double get totalAmount => widget.transactions.fold(0.0, (sum, t) => sum + (filter == TransactionType.income ? (t.isIncome ? t.amount : 0) : (t.isExpense ? t.amount : 0)));
  List<Transaction> get filtered => widget.transactions.where((t) => t.type == filter).toList();

  Map<Category, List<Transaction>> get grouped {
    Map<Category, List<Transaction>> result = {};
    for(Transaction t in filtered){
      if (!result.containsKey(t.category)) {
        result[t.category] = [];
      }
      result[t.category]!.add(t);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;

    if (widget.transactions.isEmpty) return const SizedBox();

    return Column(
      children: [
        Text(language.category, style: textTheme.headlineLarge?.copyWith(color: colorTheme.primary)),
        const SizedBox(height: 20),
        TransactionFilterButton(
          onPress: (t) {
            setState(() {
              filter = t!;
            });
          }),
        grouped.isNotEmpty? 
        Column(
          children: [
            SizedBox(
              height: 320,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      if (event is FlTapUpEvent) {
                        final touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                        if (touchedIndex != null && touchedIndex < grouped.length) {
                          final category = grouped.keys.elementAt(touchedIndex);
                          ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              content: Text(category.getLabel(language))
                              ),
                          );
                        }
                      }
                    },
                  ),
                  sectionsSpace: 6, 
                  centerSpaceRadius: 100,
                  startDegreeOffset: -90,
                  sections: grouped.entries.map((entry) {
                    Category category = entry.key;
                    List<Transaction> list = entry.value;
                    double amount = list.fold(0.0, (sum, t) => sum + t.amount);
                    String percentage = "${((amount / totalAmount) * 100).round()}%";
                    return buildSection(category, amount, percentage);
                  }).toList(),
                )
              ),
            ),
            ...grouped.entries.map((entry) {
              Category category = entry.key;
              List<Transaction> list = entry.value;
              double amount = list.fold(0.0, (sum, t) => sum + t.amount);
              String percentage = "${((amount / totalAmount) * 100).round()}%";
              return GestureDetector(
                onTap: () => widget.onTapCategory(category, list, filter),
                child: CategoryItem(
                  category: category, 
                  type: filter, 
                  percentage: percentage, 
                  amount: amount, 
                  transactionCount: list.length, 
                  amountLabel: widget.amountLabel,
                )
              );
            })
          ],
        ) : Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(language.nodata, style: TextStyle(color: Colors.grey),),
          ),
        )
      ],
    );
  }

  PieChartSectionData buildSection(Category category, double amount, String percentage) {
    return PieChartSectionData(
      value: amount,
      title: percentage,
      color: category.backgroundColor, 
      radius: 20,
      titleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titlePositionPercentageOffset: 2
    );
  }
}