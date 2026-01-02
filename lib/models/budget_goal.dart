import 'package:uuid/uuid.dart';
import './category.dart';

var uuid = Uuid();
class BudgetGoal{
  final String id;
  final Category category;
  final double goalAmount;
  final int year;
  final int month;

  BudgetGoal({
    String? id,
    required this.category,
    required this.goalAmount,
    required this.year,
    required this.month
  }) : id = id ?? uuid.v4();

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name, 
      'goalAmount': goalAmount,
      'year': year,
      'month': month,
    };
  }

  static BudgetGoal fromMap(Map<String, dynamic> map) {
    return BudgetGoal(
      id: map['id'],
      category: Category.values.firstWhere((c) => c.name == map['category']),
      goalAmount: map['goalAmount'],
      year: map['year'],
      month: map['month'],
    );
  }
}