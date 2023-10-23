class ExpenseCategory {
  String id;
  final String name;
  final String description;

  ExpenseCategory(
      {required this.id, required this.name, this.description = ''});

  factory ExpenseCategory.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return ExpenseCategory(
      id: docId,
      name: data['name'] ?? '',
    );
  }

  // Convert ExpenseCategory object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
    };
  }
}
