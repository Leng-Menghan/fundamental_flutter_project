import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import './category.dart';
enum TransactionType{
  expense(color: Colors.red),
  income(color: Colors.green);
  final Color color;
  const TransactionType({required this.color});
}

var uuid = Uuid();
class Transaction{
  final String id;
  final String title;
  final double amount;
  final Category category;
  final TransactionType type;
  final DateTime date;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date
  }) : id = id ?? uuid.v4();

  bool get isIncome => type == TransactionType.income ? true: false;
  bool get isExpense => type == TransactionType.expense ? true: false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name,        
      'type': type.name,                
      'date': date.toIso8601String(),   
    };
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: Category.values.firstWhere((c) => c.name == map['category']),
      type: TransactionType.values.firstWhere((t) => t.name == map['type'],),
      date: DateTime.parse(map['date']),
    );
  }

}