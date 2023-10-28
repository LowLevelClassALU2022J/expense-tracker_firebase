import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _expenseController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService =
      FirestoreService(FirebaseAuth.instance.currentUser!.uid);

  List<ExpenseCategory> _categories = [];
  ExpenseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firestoreService.getExpenseCategories().listen((categories) {
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) _selectedCategory = _categories[0];
      });
    });
  }

  Future<void> _addCategory(String newCategoryName) async {
    final category =
        await _firestoreService.addExpenseCategory(newCategoryName);
    if (category != null) {
      _updateUIWithNewCategory(category);
    } else {
      _showMessage('Category already exists');
    }
  }

  void _updateUIWithNewCategory(ExpenseCategory category) {
    setState(() {
      _categories.add(category);
      _selectedCategory = category;
    });
    _showMessage('Category added successfully');
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController categoryController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expense Category'),
          content: TextFormField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCategory(categoryController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('Add Expense'),
        backgroundColor: const Color(0xFF429690),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _expenseController,
                decoration: const InputDecoration(
                  labelText: 'Expense Amount',
                  hintText: 'Enter your expense',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money_off, color: Color(0xFF429690)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ExpenseCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    style: const TextStyle(color: Color(0xFF429690)),
                    items: _categories.map((ExpenseCategory category) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    hint: const Text('Select Category'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLength: 21,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description, color: Color(0xFF429690)),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Save the new expense to Firestore
                  _firestoreService.addExpense(
                    double.parse(_expenseController.text),
                    _selectedCategory!.id,
                    _descriptionController.text,
                    _selectedCategory!.name,
                  );
                  // clear the text fields
                  _expenseController.clear();
                  _descriptionController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add Expense'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showAddCategoryDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add New Expense Category'),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/expenseList');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View All Expenses'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/expenseCategoryList');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View All Expense Categories'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
