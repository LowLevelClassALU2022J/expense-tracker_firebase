import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseListScreen extends StatefulWidget {
  final FirestoreService firestoreService;
  const ExpenseListScreen({Key? key, required this.firestoreService})
      : super(key: key);

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  Stream<List<Expense>>? _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = widget.firestoreService.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
        backgroundColor: const Color(0xFF429690),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _expensesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final expenses = snapshot.data!;
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text('\$${expense.amount}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expense.categoryName),
                        const SizedBox(height: 8.0),
                        if (expense.description.isNotEmpty)
                          Text(expense.description),
                        const SizedBox(height: 8.0),
                        Text(DateFormat.yMMMd().format(expense.date)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // Show the edit dialog for the expense
                            _showEditDialog(expense);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool? confirm =
                                await _showDeleteConfirmationDialog(expense);
                            if (confirm ?? false) {
                              // Delete the expense from Firestore
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _showEditDialog(Expense expense) async {
    final TextEditingController descriptionController =
        TextEditingController(text: expense.description);
    final TextEditingController amountController =
        TextEditingController(text: expense.amount.toString());
    final TextEditingController dateController =
        TextEditingController(text: DateFormat.yMMMd().format(expense.date));
    final TextEditingController categoryController =
        TextEditingController(text: expense.categoryName);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Expense'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 10),
                // category should not be editable
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  enabled: false,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
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
                widget.firestoreService
                    .updateExpense(
                  expense.id,
                  double.parse(amountController.text),
                  expense.categoryId,
                  descriptionController.text,
                  expense.categoryName,
                )
                    .then((_) {
                  Navigator.of(context).pop(true);
                }).catchError((error) {
                  print("Error updating expense: $error");
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(Expense expense) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Expense'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                widget.firestoreService.deleteExpense(expense.id).then((_) {
                  Navigator.of(context).pop(true);
                }).catchError((error) {
                  print("Error deleting expense: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }
}
