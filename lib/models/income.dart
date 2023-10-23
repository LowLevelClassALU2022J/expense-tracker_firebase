import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  String id;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String description;
  final DateTime date;

  Income({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.description = '',
    required this.categoryName,
    required this.date,
  });

  // Convert Firestore document to Income
  factory Income.fromFirestore(Map<String, dynamic> data, String docId) {
    return Income(
      id: docId,
      amount: data['amount'],
      categoryId: data['categoryId'],
      description: data['description'] ?? '',
      categoryName: data['categoryName'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Convert Income object to a Map for Firestore
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
