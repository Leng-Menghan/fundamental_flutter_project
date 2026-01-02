import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fundamental_flutter_project/ui/screens/inspect_category.dart';
import '../../l10n/app_localization.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../../models/transaction.dart';
import 'category_item.dart';
import 'transaction_filter_button.dart';

class CategoryPieChart extends StatefulWidget {
  final User user;
  final DateTime start;
  final DateTime end;
  final VoidCallback isRefresh;
  const CategoryPieChart({super.key, required this.user, required this.start, required this.end, required this.isRefresh});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  TransactionType filter = TransactionType.income;

  void onTapCategory(Category category, List<Transaction> list, TransactionType type) async{
    bool? isChanged = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => InspectCategory(
          user: widget.user,
          category: category,
          transactions: list,
          type: type,
        ),
      ),
    );
    if(isChanged == true){
      widget.isRefresh();
    }
  }
  List<Transaction> get transactions => widget.user.getTransactionsDuration(start: widget.start, end: widget.end);
  double get totalAmount => widget.user.getTotalAmountByType(transactionList: transactions, type: filter);
  Map<Category, List<Transaction>> get grouped => widget.user.groupTransactionsByCategoryAndType(transactions, filter);
  
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;

    if (transactions.isEmpty) return const SizedBox();

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
                              content: Text(category.label)
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
                onTap: () => onTapCategory(category, list, filter),
                child: CategoryItem(
                  category: category, 
                  type: filter, 
                  percentage: percentage, 
                  amount: amount, 
                  transactionCount: list.length
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