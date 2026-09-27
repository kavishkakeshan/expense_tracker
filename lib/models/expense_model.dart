import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Convert an Expense object to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // ✅ Added userId
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Create an Expense object from a Map retrieved from Firestore
  factory Expense.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parsedDate;
    if (map['date'] is String) {
      parsedDate = DateTime.tryParse(map['date'] as String) ?? DateTime.now();
    } else if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return Expense(
      id: docId,
      userId: map['userId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category']?.toString() ?? 'General',
      date: parsedDate,
      note: map['note']?.toString(),
    );
  }
}