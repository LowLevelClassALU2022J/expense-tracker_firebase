import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeListScreen extends StatefulWidget {
  final FirestoreService firestoreService;

  const IncomeListScreen({Key? key, required this.firestoreService})
      : super(key: key);

  @override
  _IncomeListScreenState createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends State<IncomeListScreen> {
  Stream<List<Income>>? _incomesStream;

  @override
  void initState() {
    super.initState();
    _incomesStream = widget.firestoreService.getIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income List'),
        backgroundColor: const Color(0xFF429690),
      ),
      body: StreamBuilder<List<Income>>(
        stream: _incomesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final incomes = snapshot.data!;
            return ListView.builder(
              itemCount: incomes.length,
              itemBuilder: (context, index) {
                final income = incomes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text('\$${income.amount}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(income.categoryName),
                        const SizedBox(height: 8.0),
                        if (income.description.isNotEmpty)
                          Text(income.description),
                        const SizedBox(height: 8.0),
                        Text(DateFormat.yMMMd().format(income.date)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // Show the edit dialog for the income
                            _showEditDialog(income);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool? confirm =
                                await _showDeleteConfirmationDialog(income);
                            if (confirm ?? false) {
                              // Delete the income from Firestore
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

  Future<void> _showEditDialog(Income income) async {
    final TextEditingController descriptionController =
        TextEditingController(text: income.description);
    final TextEditingController amountController =
        TextEditingController(text: income.amount.toString());
    final TextEditingController dateController =
        TextEditingController(text: DateFormat.yMMMd().format(income.date));
    final TextEditingController categoryController =
        TextEditingController(text: income.categoryName);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Income'),
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
                    .updateIncome(
                      income.id,
                      double.parse(amountController.text),
                      income.categoryId,
                      descriptionController.text,
                      income.categoryName,
                    )
                    .then((value) => {Navigator.of(context).pop(true)})
                    .catchError((error) {
                  print("Error updating income: $error");
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(Income income) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Income'),
          content: const Text('Are you sure you want to delete this income?'),
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
                // Delete the income from Firestore
                widget.firestoreService.deleteIncome(income.id).then((_) {
                  Navigator.of(context).pop(true);
                }).catchError((error) {
                  print("Error deleting income: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }
}
