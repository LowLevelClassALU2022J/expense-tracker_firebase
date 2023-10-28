import 'package:expense_tracker/models/income_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/firestore_service.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _incomeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestoreService =
      FirestoreService(FirebaseAuth.instance.currentUser!.uid);

  List<IncomeCategory> _categories = [];
  IncomeCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _firestoreService.getIncomeCategories().listen((categories) {
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) _selectedCategory = _categories[0];
      });
    });
  }

  Future<void> _addCategory(String newCategoryName) async {
    final category = await _firestoreService.addIncomeCategory(newCategoryName);
    if (category != null) {
      _updateUIWithNewCategory(category);
    } else {
      _showMessage('Category already exists');
    }
  }

  void _updateUIWithNewCategory(IncomeCategory category) {
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
          title: const Text('Add New Category'),
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
        title: const Text('Add Income'),
        backgroundColor: const Color(0xFF429690),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _incomeController,
                decoration: const InputDecoration(
                  labelText: 'Income Amount',
                  hintText: 'Enter your income',
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.attach_money, color: Color(0xFF429690)),
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
                  child: DropdownButton<IncomeCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    style: const TextStyle(color: Color(0xFF429690)),
                    items: _categories.map((IncomeCategory category) {
                      return DropdownMenuItem<IncomeCategory>(
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
                onPressed: () async {
                  // Save the new income to Firestore
                  _firestoreService.addIncome(
                    double.parse(_incomeController.text),
                    _selectedCategory!.id,
                    _descriptionController.text,
                    _selectedCategory!.name,
                  );
                  // clear the text fields
                  _incomeController.clear();
                  _descriptionController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add Income'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showAddCategoryDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Add New Income Category'),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/incomeList');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View All Income'),
              ),
              // button for view all income categories
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/incomeCategoryList');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF429690),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('View All Income Categories'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
