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
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Create an Expense object from a Map retrieved from Firestore
  factory Expense.fromMap(Map<String, dynamic> map, String docId) {
    return Expense(
      id: docId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? 'General',
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
