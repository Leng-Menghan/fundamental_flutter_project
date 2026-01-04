import 'package:flutter/material.dart';

import '../l10n/app_localization.dart';

enum Category {
  // Expense
  bill(icon: 'assets/expenseIcons/bill.png', backgroundColor: Colors.redAccent),
  clothing(icon: "assets/expenseIcons/cloth.png", backgroundColor: Colors.indigo),
  education(icon: "assets/expenseIcons/education.png", backgroundColor: Colors.blueGrey),
  entertainment(icon: "assets/expenseIcons/entertainment.png", backgroundColor: Colors.deepPurple),
  fitness(icon: "assets/expenseIcons/fitness.png", backgroundColor: Colors.teal),
  food(icon: "assets/expenseIcons/food.png", backgroundColor: Colors.orangeAccent),
  gift(icon: "assets/expenseIcons/gift.png", backgroundColor: Colors.pinkAccent),
  health(icon: "assets/expenseIcons/health.png", backgroundColor: Colors.red),
  furniture(icon: "assets/expenseIcons/furniture.png", backgroundColor: Colors.brown),
  pet(icon: "assets/expenseIcons/pets.png", backgroundColor: Colors.deepOrange),
  shopping(icon: "assets/expenseIcons/shopping.png", backgroundColor: Colors.purple),
  transportation(icon: "assets/expenseIcons/transportation.png", backgroundColor: Colors.blueAccent),
  travel(icon: "assets/expenseIcons/bill.png", backgroundColor: Colors.amber),
  otherExpense(icon: "assets/expenseIcons/other.png", backgroundColor: Color(0xFF616161)),
  // Income
  allowance(icon: "assets/incomeIcons/allowance.png", backgroundColor: Colors.deepPurple), // Dark Green
  award(icon: "assets/incomeIcons/award.png", backgroundColor: Colors.red), // Medium Green
  bonus(icon: "assets/incomeIcons/bonus.png", backgroundColor: Colors.orangeAccent), // Deep Green
  dividend(icon: "assets/incomeIcons/dividends.png", backgroundColor: Colors.blueGrey), // Teal
  investment(icon: "assets/incomeIcons/investment.png", backgroundColor: Colors.indigo), // Cyan
  lottery(icon: "assets/incomeIcons/lottery.png", backgroundColor: Colors.teal), // Olive Green
  salary(icon: "assets/incomeIcons/salary.png", backgroundColor: Colors.amber), // Forest Green
  tip(icon: "assets/incomeIcons/tip.png", backgroundColor: Colors.blueAccent),// Medium Green
  otherIncome(icon: "assets/expenseIcons/other.png", backgroundColor: Color(0xFF616161));
  
  final String icon;
  final Color backgroundColor;
  const Category({required this.icon, required this.backgroundColor});

  static List<Category> get incomeCategories => [
    allowance,
    award,
    bonus,
    dividend,
    investment,
    lottery,
    salary,
    tip,
    otherIncome,
  ];

  static List<Category> get expenseCategories => [
    bill,
    clothing,
    education,
    entertainment,
    fitness,
    food,
    gift,
    health,
    furniture,
    pet,
    shopping,
    transportation,
    travel,
    otherExpense
  ];

  String getLabel(AppLocalizations language) {
    switch (this) {
      case Category.bill: return language.bill;
      case Category.clothing: return language.cloth;
      case Category.education: return language.education;
      case Category.entertainment:return language.entertainment;
      case Category.fitness: return language.fitness;
      case Category.food:return language.food;
      case Category.gift:return language.gift;
      case Category.health:return language.health;
      case Category.furniture:return language.furniture;
      case Category.pet:return language.pet;
      case Category.shopping:return language.shopping;
      case Category.transportation:return language.transportation;
      case Category.travel:return language.travel;
      case Category.otherExpense: return language.other;
      case Category.allowance:return language.allowance;
      case Category.award:return language.award;
      case Category.bonus:return language.bonus;
      case Category.dividend:return language.dividend;
      case Category.investment:return language.investment;
      case Category.lottery:return language.lottery;
      case Category.salary: return language.salary;
      case Category.tip:return language.tip;
      case Category.otherIncome:return language.other;
    }
  }
}


