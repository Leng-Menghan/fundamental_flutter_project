import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  


  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  void _addBudget() async {
    List<Category> avaliableCategories = widget.user.getAvaliableCategories(_date.year, _date.month);
    final result = await Navigator.push<BudgetGoal>(
      context,
      MaterialPageRoute(builder: (_) => CreateBudget(date: _date, avaliableCategories: avaliableCategories)),
    );
    if (result != null) {
      await widget.user.addBudgetGoal(result);
      setState(() {});
    }
  }
  void _editBudget(BudgetGoal budget) async{
    List<Category> avaliableCategories = [...widget.user.getAvaliableCategories(_date.year, _date.month), budget.category];
    final result = await Navigator.push<BudgetGoal>(
      context,
      MaterialPageRoute(builder: (_) => CreateBudget(date: _date, edit: budget, avaliableCategories: avaliableCategories)),
    );
    if (result != null) {
      await widget.user.updateBudgetGoal(result, budget.id);
      setState(() {});
    }
  }

  void _onDelete(String id) async{
    await widget.user.removeBudgetGoal(id);
    setState(() {});
  }

  void _onUndo(BudgetGoal g) async{
    await widget.user.addBudgetGoal(g);
    setState(() {});
  }

  void _onNextMonth(){
    setState(() {
      _date = DateTime(_date.year, _date.month + 1);
    });
  }

  void _onPreMonth(){
    setState(() {
      _date = DateTime(_date.year, _date.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final List<BudgetGoal> budgetGoals = widget.user.getBudgetGoal(year: _date.year, month: _date.month);
    final double totalGoal = widget.user.getTotalGoal(_date.year, _date.month);
    final double totalSpent = widget.user.getTotalSpent(_date.year, _date.month);

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
                  Header(greeting: "Good Evening", userName: "Ren Sodalin", onPress: _addBudget, profileLabel: "RS",),
                  const SizedBox(height: 10),
                  DashboardBudgetGoal(goal: totalGoal, spent: totalSpent),
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
                                      _onDelete(goal.id);
                                      ScaffoldMessenger.of(context)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text("Budget Goal deleted"),
                                          behavior: SnackBarBehavior.floating,
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () => _onUndo(goal)
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



