import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';

class FirestoreService {
  final CollectionReference _expenseCollection = FirebaseFirestore.instance
      .collection('expenses');

  // Add new expense
  Future<void> addExpense(Expense expense) async {
    try {
      await _expenseCollection.add(expense.toMap());
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  // Update existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      await _expenseCollection.doc(expense.id).update(expense.toMap());
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    try {
      await _expenseCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  // Stream expenses (Real-time updates + optional category filter)
  Stream<List<Expense>> getExpenses({
    required String userId,
    String? category,
  }) {
    return _expenseCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<Expense> expenses = snapshot.docs.map((doc) {
            return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (category != null && category != 'All') {
            expenses = expenses.where((e) => e.category == category).toList();
          }

          expenses.sort((a, b) => b.date.compareTo(a.date));

          return expenses;
        });
  }

  // Calculate current month total
  double calculateMonthlyTotal(List<Expense> expenses, DateTime currentMonth) {
    return expenses
        .where(
          (e) =>
              e.date.year == currentMonth.year &&
              e.date.month == currentMonth.month,
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
