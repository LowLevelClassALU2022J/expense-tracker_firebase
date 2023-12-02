import 'package:expense_tracker/models/income_category.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter/material.dart';

class EditIncomeCategoryScreen extends StatefulWidget {
  final FirestoreService firestoreService;

  const EditIncomeCategoryScreen({Key? key, required this.firestoreService})
      : super(key: key);

  @override
  _EditIncomeCategoryScreenState createState() =>
      _EditIncomeCategoryScreenState();
}

class _EditIncomeCategoryScreenState extends State<EditIncomeCategoryScreen> {
  Stream<List<IncomeCategory>>? _categoriesStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = widget.firestoreService.getIncomeCategories();
  }

  Future<void> _showEditDialog(IncomeCategory category) async {
    String? updatedName = category.name;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: category.name,
                onChanged: (value) {
                  updatedName = value;
                },
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              // You can add more fields like description if needed
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (updatedName != null && updatedName!.trim().isNotEmpty) {
                  // Update category in Firebase
                  await widget.firestoreService
                      .updateIncomeCategory(updatedName!.trim(), category.id);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(IncomeCategory category) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.firestoreService
                    .deleteIncomeCategory(category.id)
                    .then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print("Error deleting category: $error");
                  // Optionally show an error dialog or Snackbar here.
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Income Categories"),
        backgroundColor: const Color(0xFF429690),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // go back to previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<IncomeCategory>>(
        stream: _categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No categories found"));
          } else {
            final _categories = snapshot.data!;
            return ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: new Color(0xFF429690),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () async {
                          await _showEditDialog(category);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () async {
                          await _showDeleteDialog(category);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
