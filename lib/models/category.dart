import 'package:flutter/material.dart';
import '../l10n/app_localization.dart';

// enum Category {
//   // Expense
//   bill(icon: 'assets/expenseIcons/bill.png', backgroundColor: Colors.redAccent),
//   clothing(icon: "assets/expenseIcons/cloth.png", backgroundColor: Colors.indigo),
//   education(icon: "assets/expenseIcons/education.png", backgroundColor: Colors.blueGrey),
//   entertainment(icon: "assets/expenseIcons/entertainment.png", backgroundColor: Colors.deepPurple),
//   fitness(icon: "assets/expenseIcons/fitness.png", backgroundColor: Colors.teal),
//   food(icon: "assets/expenseIcons/food.png", backgroundColor: Colors.orangeAccent),
//   gift(icon: "assets/expenseIcons/gift.png", backgroundColor: Colors.pinkAccent),
//   health(icon: "assets/expenseIcons/health.png", backgroundColor: Colors.red),
//   furniture(icon: "assets/expenseIcons/furniture.png", backgroundColor: Colors.brown),
//   pet(icon: "assets/expenseIcons/pets.png", backgroundColor: Colors.deepOrange),
//   shopping(icon: "assets/expenseIcons/shopping.png", backgroundColor: Colors.purple),
//   transportation(icon: "assets/expenseIcons/transportation.png", backgroundColor: Colors.blueAccent),
//   travel(icon: "assets/expenseIcons/bill.png", backgroundColor: Colors.amber),
//   // Income
//   allowance(icon: "assets/incomeIcons/allowance.png", backgroundColor: Colors.deepPurple),
//   award(icon: "assets/incomeIcons/award.png", backgroundColor: Colors.red),
//   bonus(icon: "assets/incomeIcons/bonus.png", backgroundColor: Colors.orangeAccent),
//   dividend(icon: "assets/incomeIcons/dividends.png", backgroundColor: Colors.blueGrey),
//   investment(icon: "assets/incomeIcons/investment.png", backgroundColor: Colors.indigo),
//   lottery(icon: "assets/incomeIcons/lottery.png", backgroundColor: Colors.teal),
//   salary(icon: "assets/incomeIcons/salary.png", backgroundColor: Colors.amber),
//   tip(icon: "assets/incomeIcons/tip.png", backgroundColor: Colors.blueAccent),
//   other(icon: "assets/expenseIcons/other.png", backgroundColor: Color(0xFF616161));

//   final String icon;
//   final Color backgroundColor;

//   const Category({required this.icon, required this.backgroundColor});

//   static List<Category> get incomeCategories => [
//         allowance,
//         award,
//         bonus,
//         dividend,
//         investment,
//         lottery,
//         salary,
//         tip,
//         other,
//       ];

//   static List<Category> get expenseCategories => [
//         bill,
//         clothing,
//         education,
//         entertainment,
//         fitness,
//         food,
//         gift,
//         health,
//         furniture,
//         pet,
//         shopping,
//         transportation,
//         travel,
//         other
//       ];
// }

// extension CategoryExtension on Category {
//   String label(AppLocalizations language) {
//     switch (this) {
//       case Category.bill:
//         return language.bill;
//       case Category.clothing:
//         return language.cloth;
//       case Category.education:
//         return language.education;
//       case Category.entertainment:
//         return language.entertainment;
//       case Category.fitness:
//         return language.fitness;
//       case Category.food:
//         return language.food;
//       case Category.gift:
//         return language.gift;
//       case Category.health:
//         return language.health;
//       case Category.furniture:
//         return language.furniture;
//       case Category.pet:
//         return language.pet;
//       case Category.shopping:
//         return language.shopping;
//       case Category.transportation:
//         return language.transportation;
//       case Category.travel:
//         return language.travel;
//       case Category.allowance:
//         return language.allowance;
//       case Category.award:
//         return language.award;
//       case Category.bonus:
//         return language.bonus;
//       case Category.dividend:
//         return language.dividend;
//       case Category.investment:
//         return language.investment;
//       case Category.lottery:
//         return language.lottery;
//       case Category.tip:
//         return language.tip;
//       case Category.salary:
//         return language.salary;
//       case Category.other:
//         return language.other;
//     }
//   }
// }

enum Category {
  // Expense
  bill(icon: 'assets/expenseIcons/bill.png', backgroundColor: Colors.redAccent, label: "Bills"),
  clothing(icon: "assets/expenseIcons/cloth.png", backgroundColor: Colors.indigo, label: "Clothing"),
  education(icon: "assets/expenseIcons/education.png", backgroundColor: Colors.blueGrey, label: "Education"),
  entertainment(icon: "assets/expenseIcons/entertainment.png", backgroundColor: Colors.deepPurple, label: "Entertainment"),
  fitness(icon: "assets/expenseIcons/fitness.png", backgroundColor: Colors.teal, label: "Fitness"),
  food(icon: "assets/expenseIcons/food.png", backgroundColor: Colors.orangeAccent, label: "Food"),
  gift(icon: "assets/expenseIcons/gift.png", backgroundColor: Colors.pinkAccent, label: "Gifts"),
  health(icon: "assets/expenseIcons/health.png", backgroundColor: Colors.red, label: "Health"),
  furniture(icon: "assets/expenseIcons/furniture.png", backgroundColor: Colors.brown, label: "Furniture"),
  pet(icon: "assets/expenseIcons/pets.png", backgroundColor: Colors.deepOrange, label: "Pets"),
  shopping(icon: "assets/expenseIcons/shopping.png", backgroundColor: Colors.purple, label: "Shopping"),
  transportation(icon: "assets/expenseIcons/transportation.png", backgroundColor: Colors.blueAccent, label: "Transportation"),
  travel(icon: "assets/expenseIcons/bill.png", backgroundColor: Colors.amber, label: "Travel"),
  otherExpense(icon: "assets/expenseIcons/other.png", backgroundColor: Color(0xFF616161), label: "Others"),
  // Income
  allowance(icon: "assets/incomeIcons/allowance.png", backgroundColor: Colors.deepPurple, label: "Allowance"), // Dark Green
  award(icon: "assets/incomeIcons/award.png", backgroundColor: Colors.red, label: "Award"), // Medium Green
  bonus(icon: "assets/incomeIcons/bonus.png", backgroundColor: Colors.orangeAccent, label: "Bonus"), // Deep Green
  dividend(icon: "assets/incomeIcons/dividends.png", backgroundColor: Colors.blueGrey, label: "Dividend"), // Teal
  investment(icon: "assets/incomeIcons/investment.png", backgroundColor: Colors.indigo, label: "Investment"), // Cyan
  lottery(icon: "assets/incomeIcons/lottery.png", backgroundColor: Colors.teal, label: "Lottery"), // Olive Green
  salary(icon: "assets/incomeIcons/salary.png", backgroundColor: Colors.amber, label: "Salary"), // Forest Green
  tip(icon: "assets/incomeIcons/tip.png", backgroundColor: Colors.blueAccent, label: "Tips"),// Medium Green
  otherIncome(icon: "assets/expenseIcons/other.png", backgroundColor: Color(0xFF616161), label: "Others");
  
  final String icon;
  final Color backgroundColor;
  final String label;
  const Category({required this.icon, required this.backgroundColor, required this.label});

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
}


