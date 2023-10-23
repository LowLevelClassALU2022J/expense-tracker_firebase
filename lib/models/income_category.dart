class IncomeCategory {
  String id;
  final String name;
  final String description;

  IncomeCategory({required this.id, required this.name, this.description = ''});

  factory IncomeCategory.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return IncomeCategory(
      id: docId,
      name: data['name'] ?? '',
    );
  }

  // Convert IncomeCategory object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
    };
  }
}
