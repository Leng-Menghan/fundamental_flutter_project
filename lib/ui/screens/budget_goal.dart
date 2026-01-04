import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fundamental_flutter_project/utils/animations_util.dart';
import '../../l10n/app_localization.dart';
import '../widgets/cus_month_switcher.dart';
import '../../models/user.dart';
import '../widgets/category_budget_goal.dart';
import '../widgets/dashboard_budget_goal.dart';
import '../widgets/header.dart';
import '../../models/budget_goal.dart';
import '../../models/category.dart';
import 'budget_goal_form.dart';

class BudgetGoalScreen extends StatefulWidget {
  final User user;
  const BudgetGoalScreen({super.key, required this.user});

  @override
  State<BudgetGoalScreen> createState() => _BudgetGoalScreenState();
}

class _BudgetGoalScreenState extends State<BudgetGoalScreen> {
  DateTime _date = DateTime.now();
  late List<BudgetGoal> budgetGoals;

  @override
  void initState(){
    budgetGoals = widget.user.getBudgetGoal(year: _date.year, month: _date.month);
    super.initState();
  }
  double get totalGoal => budgetGoals.fold(0.0, (sum, b) => sum + b.goalAmount);
  double get totalSpent => widget.user.getTotalSpent(_date.year, _date.month);

  void _addBudget() async {
    List<Category> avaliableCategories = widget.user.getAvailableleCategories(_date.year, _date.month);
    final result = await Navigator.push<BudgetGoal>(
      context,
      AnimationUtils.rotateWithFade(CreateBudget(date: _date, avaliableCategories: avaliableCategories, amountLabel: amountLabel,))
    );
    if (result != null) {
      await widget.user.addBudgetGoal(result);
      setState(() {
        budgetGoals.add(result);
      });
    }
  }

  void _editBudget(BudgetGoal budget) async{
    List<Category> avaliableCategories = [...widget.user.getAvailableleCategories(_date.year, _date.month), budget.category];
    final result = await Navigator.push<BudgetGoal>(
      context,
      AnimationUtils.slideBTWithFade(CreateBudget(date: _date, edit: budget, avaliableCategories: avaliableCategories, amountLabel: amountLabel,))
    );
    if (result != null) {
      await widget.user.updateBudgetGoal(result, budget.id);
      setState(() {
        budgetGoals = budgetGoals.map((b) => b.id == budget.id ? result : b).toList();
      });
    }
  }

  void _onDelete(String id, int index) async{
    await widget.user.removeBudgetGoal(id);
    setState(() {
      budgetGoals.removeAt(index);
    });
  }

  void _onUndo(BudgetGoal g, int index) async{
    await widget.user.addBudgetGoal(g);
    setState(() {
      budgetGoals.insert(index, g);
    });
  }

  void _onNextMonth(){
    setState(() {
      _date = DateTime(_date.year, _date.month + 1);
      budgetGoals = widget.user.getBudgetGoal(year: _date.year, month: _date.month);
    });
  }

  void _onPreMonth(){
    setState(() {
      _date = DateTime(_date.year, _date.month - 1);
      budgetGoals = widget.user.getBudgetGoal(year: _date.year, month: _date.month);
    });
  }
  String get amountLabel => widget.user.preferredAmountType == AmountType.dollar ? "\$" : "៛";
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final language = AppLocalizations.of(context)!;
    
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
                  color: colorTheme.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(greeting: widget.user.getLocalizedGreeting(language), userName: widget.user.name, onPress: _addBudget, profileLabel: widget.user.getProfileLabel(),),
                  const SizedBox(height: 10),
                  DashboardBudgetGoal(goal: totalGoal, spent: totalSpent, amountLabel: amountLabel,),
                  const SizedBox(height: 20),
                  CustomMonthSwitcher(onNext: _onNextMonth, onBack: _onPreMonth, date: _date, isBig: true),
                  const SizedBox(height: 15),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Category",
                            style: textTheme.titleLarge?.copyWith(
                              color: colorTheme.onSurface
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Goal",
                            textAlign: TextAlign.center,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorTheme.onSurface
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Spent",
                            textAlign: TextAlign.end,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorTheme.onSurface
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  const SizedBox(height: 10),
                  budgetGoals.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: budgetGoals.length,
                          itemBuilder: (context, index) {
                            final goal = budgetGoals[index];
                            final double spent = widget.user.getSpentCategory(_date.year, _date.month, goal.category);
                            return Slidable(
                              key: ValueKey(goal.id),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.2,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => _editBudget(goal),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.blue,
                                    icon: Icons.edit,
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.2,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      _onDelete(goal.id, index);
                                      ScaffoldMessenger.of(context)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text("Budget Goal deleted"),
                                          behavior: SnackBarBehavior.floating,
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () => _onUndo(goal, index)
                                          ),
                                        )
                                      );
                                    },
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete,
                                  ),
                                ],
                              ),
                              child: CategoryBudgetGoal(
                                category: goal.category,
                                goal: goal.goalAmount,
                                spent: spent, 
                                amountLabel: amountLabel,
                              )
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              "No budget goals yet",
                              style: textTheme.titleMedium?.copyWith(
                                color:colorTheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



