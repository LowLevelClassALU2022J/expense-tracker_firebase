import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String description;
  final DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.description = '',
    required this.categoryName,
    required this.date,
  });

  // Convert Firestore document to Expense
  factory Expense.fromFirestore(Map<String, dynamic> data, String docId) {
    return Expense(
      id: docId,
      amount: data['amount'],
      categoryId: data['categoryId'],
      description: data['description'] ?? '',
      categoryName: data['categoryName'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Convert Expense object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'categoryId': categoryId,
      'description': description,
      'categoryName': categoryName,
      'date': Timestamp.fromDate(date),
    };
  }
}
