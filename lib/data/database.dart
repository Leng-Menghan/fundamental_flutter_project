import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/budget_goal.dart';
import '../models/transaction.dart' as model;
import '../models/user.dart';

class DBHelper {
  static Database? _db;

  static Future<void> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'SmartFinance.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            title TEXT,
            amount REAL,
            category TEXT,
            type TEXT,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE budget_goals(
            id TEXT PRIMARY KEY,
            category TEXT,
            goalAmount REAL,
            year INTEGER,
            month INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE user(
            id TEXT PRIMARY KEY,
            name TEXT,
            profileImage TEXT,
            preferredLanguage TEXT,
            preferredAmountType TEXT
          )
        ''');
      },
    );
  }

  static Future<Database> get database async{
    if(_db != null) return _db!;
    await initDatabase();
    return _db!;
  }

  static Future<void> insertTransaction(model.Transaction t) async {
    final db = await database;
    await db.insert('transactions', t.toMap());
  }

  static Future<List<model.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return maps.map((map) => model.Transaction.fromMap(map)).toList();
  }

  static Future<void> updateTransaction(model.Transaction t) async {
    final db = await database;
    await db.update('transactions', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  static Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertBudgetGoal(BudgetGoal b) async {
    final db = await database;
    await db.insert('budget_goals', b.toMap());
  }

  static Future<List<BudgetGoal>> getBudgetGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budget_goals');
    return maps.map((map) => BudgetGoal.fromMap(map)).toList();
  }

  static Future<void> updateBudgetGoal(BudgetGoal b) async {
    final db = await database;
    await db.update('budget_goals', b.toMap(), where: 'id = ?', whereArgs: [b.id]);
  }

  static Future<void> deleteBudgetGoal(String id) async {
    final db = await database;
    await db.delete('budget_goals', where: 'id = ?', whereArgs: [id]);
  }


  static Future<void> createUser(User user) async {
    final db = await database;
    await db.insert('user', {
      'id': "oneUser",
      'name': user.name,
      'profileImage': user.profileImage,
      'preferredLanguage': user.preferredLanguage.name,
      'preferredAmountType': user.preferredAmountType.name,
    },
    conflictAlgorithm: ConflictAlgorithm.replace, // replace existing row
    );
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('user');
    if(result.isEmpty) return null;
    return result.first;
  }
}
