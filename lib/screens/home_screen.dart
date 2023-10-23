import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/services/firestore_service.dart';
import 'package:expense_tracker/widgets/credit_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestoreService =
      FirestoreService(FirebaseAuth.instance.currentUser!.uid);
  late Future<Income?> latestIncome;
  late Future<Expense?> latestExpense;

  @override
  void initState() {
    super.initState();
    latestIncome = _firestoreService.getLatestIncome();
    latestExpense = _firestoreService.getLatestExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 170,
                child: CreditCardWidget(),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  'Recent Activity',
                  style: TextStyle(
                      color: Color(0xFF429690), fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder<Income?>(
                future: latestIncome,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                      leading: CircularProgressIndicator(
                          color: Color.fromARGB(255, 47, 125, 121)),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${snapshot.error}'),
                      leading:
                          const Icon(Icons.error, color: Color(0xFF429690)),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const ListTile(
                      title: Text('No latest income found'),
                      leading: Icon(Icons.info, color: Color(0xFF429690)),
                    );
                  } else {
                    Income latest = snapshot.data!;
                    return ListTile(
                      title: const Text(
                        'Latest Income',
                        style: TextStyle(
                            color: Color(0xFF429690),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '\$${latest.amount} on ${DateFormat.yMMMMd().format(latest.date)}'),
                      leading: const Icon(Icons.arrow_upward,
                          color: Color(0xFF429690)),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<Expense?>(
                future: latestExpense,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                      leading: CircularProgressIndicator(
                          color: Color.fromARGB(255, 47, 125, 121)),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${snapshot.error}'),
                      leading:
                          const Icon(Icons.error, color: Color(0xFF429690)),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const ListTile(
                      title: Text('No latest expense found'),
                      leading: Icon(Icons.info, color: Color(0xFF429690)),
                    );
                  } else {
                    Expense latest = snapshot.data!;
                    return ListTile(
                      title: const Text(
                        'Latest Expense',
                        style: TextStyle(
                            color: Color(0xFF429690),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '\$${latest.amount} on ${DateFormat.yMMMMd().format(latest.date)}'),
                      leading: const Icon(Icons.arrow_downward,
                          color: Color(0xFF429690)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
