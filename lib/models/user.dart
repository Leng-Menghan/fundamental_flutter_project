import 'package:fundamental_flutter_project/data/database.dart';

import '../l10n/app_localization.dart';
import './category.dart';
import './budget_goal.dart';
import './transaction.dart';

enum Language{
  khmer(imageAsset: "assets/cambodia_flag.png", name: "ខ្មែរ / Khmer"),
  english(imageAsset: "assets/england_flag.png", name: "អង់គ្លេស / English");

  final String imageAsset;
  final String name;
  const Language({required this.imageAsset, required this.name});
}

enum AmountType{
  riel(imageAsset: "assets/riel.png", name: "Riels"),
  dollar(imageAsset: "assets/dollar.png", name: "Dollars");

  final String imageAsset;
  final String name;
  const AmountType({required this.imageAsset, required this.name});
}

class User {
  String name;
  String profileImage;
  Language preferredLanguage;
  AmountType preferredAmountType;
  final List<Transaction> transactions;
  final List<BudgetGoal> budgetGoals;
  
  User({
    required this.name, 
    required this.profileImage,
    required this.preferredAmountType,
    required this.preferredLanguage,
    required this.transactions,
    required this.budgetGoals
  });

  void setName(String newName) {
    name = newName;
  }

  void setLanguage(Language lang) {
    preferredLanguage = lang;
  }

  void setAmountType(AmountType type) {
    preferredAmountType = type;
  }

  String getLocalizedGreeting(AppLocalizations language) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return language.goodMorning;
    } else if (hour >= 12 && hour < 18) {
      return language.goodAfternoon;
    } else {
      return language.goodEvening;
    }
  }
  
  List<Transaction> getTransactionsDuration({required DateTime start, required DateTime end}){
    List<Transaction> list = transactions.where((t) {
      final txDate = DateTime(t.date.year, t.date.month, t.date.day);
      final startDate = DateTime(start.year, start.month, start.day);
      final endDate = DateTime(end.year, end.month, end.day);
      if (txDate.isBefore(startDate)) return false; 
      if (txDate.isAfter(endDate)) return false; 
      return true;
    }).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Map<Category, List<Transaction>> groupTransactionsByCategoryAndType(List<Transaction> transactions, TransactionType type) {
    Map<Category, List<Transaction>> result = {};
    for (var t in transactions) {
      if (t.type != type) continue; 
      if (!result.containsKey(t.category)) {
        result[t.category] = [];
      }
      result[t.category]!.add(t);
    }
    return result;
  }

  List<double> getWeeklyData(List<DateTime> week, TransactionType type) {
    return week.map((day) {
      double total = transactions
          .where((tx) =>
              tx.type == type &&
              tx.date.year == day.year &&
              tx.date.month == day.month &&
              tx.date.day == day.day)
          .fold(0.0, (sum, tx) => sum + tx.amount);
      return total;
    }).toList();
  }

  String getProfileLabel() {
    final words = name.trim().split(' ');
    final initials = words.map((word) => word[0].toUpperCase()).join();
    return initials;
  }

  Future<void> addTransaction(Transaction transaction) async{
    transactions.add(transaction);
    await DBHelper.insertTransaction(transaction);
  }

  Future<void> removeTransaction(String id) async{
    transactions.removeWhere((t) => t.id == id);
    await DBHelper.deleteTransaction(id);
  }

  Future<void> updateTransaction(Transaction updated, String id) async{
    int index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = updated; 
    } 
    await DBHelper.updateTransaction(updated);
  }

  List<Transaction> getTransactions({int? year, int? month, int? day, TransactionType? type, Category? category}){
    List<Transaction> list = transactions.where((t) {
      if (year != null && t.date.year != year) return false;
      if (month != null && t.date.month != month) return false;
      if (day != null && t.date.day != day) return false;
      if (type != null && t.type != type) return false;
      if (category != null && t.category != category) return false;
      return true;
    }).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  double getTotalAmountByType({List<Transaction>? transactionList, required TransactionType type}) {
    double total = 0;
    final listToSum = transactionList ?? transactions;
    for (var t in listToSum) {
      if(t.type == type){
        total += t.amount;
      }
    }
    return total;
  }
  
  List<Transaction> getTransactionsToday({TransactionType? type}){
    List<Transaction> list = transactions.where((t) {
      if(t.date.day != DateTime.now().day) return false;
      if(t.date.month != DateTime.now().month) return false;
      if(t.date.year != DateTime.now().year) return false;
      if(type != null && t.type != type) return false;
      return true;
    }).toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  double getTotalBalance({List<Transaction>? transactionList}){
    double total = 0;
    final listToSum = transactionList ?? transactions;
    for(Transaction t in listToSum){
      if(t.isIncome){
        total += t.amount;
      }else{
        total -= t.amount;
      }
    }
    return total;
  }


  Future<void> addBudgetGoal(BudgetGoal budgetGoal) async{
    budgetGoals.add(budgetGoal);
    await DBHelper.insertBudgetGoal(budgetGoal);
  }

  Future<void> removeBudgetGoal(String id) async{
    budgetGoals.removeWhere((b) => b.id == id);
    await DBHelper.deleteBudgetGoal(id);
  }

  Future<void> updateBudgetGoal(BudgetGoal updated, String id) async{
    int index = budgetGoals.indexWhere((b) => b.id == id);
    if(index != -1){
      budgetGoals[index] = updated;
    }
    await DBHelper.updateBudgetGoal(updated);
  }

  List<BudgetGoal> getBudgetGoal({int? year, int? month}){
    return budgetGoals.where((b) {
      if(year != null && b.year != year) return false;
      if (month != null && b.month != month) return false;
      return true;
    }).toList();
  }

  double getTotalGoal(int year, int month){
    List<BudgetGoal> budgetGoals = getBudgetGoal(year: year, month: month);
    double totalGoal = 0;
    for (BudgetGoal goal in budgetGoals) {
      totalGoal += goal.goalAmount;
    }
    return totalGoal;
  }

  double getSpentCategory(int year, int month, Category category){
    List<Transaction> transactionsList = getTransactions(year: year, month: month, category: category);
    return getTotalAmountByType(transactionList: transactionsList,type: TransactionType.expense);
  }

  double getTotalSpent(int year, int month) {
    List<BudgetGoal> budgetGoals = getBudgetGoal(year: year, month: month);
    double totalSpent = 0;
    for (BudgetGoal goal in budgetGoals) {
      totalSpent += getSpentCategory(year, month, goal.category);
    }
    return totalSpent;
  }

  List<Category> getAvaliableCategories(int year, int month){
    List<BudgetGoal> budgetGoals = getBudgetGoal(year: year, month: month);
    List<Category> usedCategories = budgetGoals.map((g) => g.category).toList();
    List<Category> avaliableCategories = Category.expenseCategories.where((c) => !usedCategories.contains(c)).toList();
    return avaliableCategories;
  }
}