import 'package:expense_tracker/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  late Future<double> totalBalance;
  late Future<double> totalIncome;
  late Future<double> totalExpenses;

  final _firestoreService =
      FirestoreService(FirebaseAuth.instance.currentUser!.uid);

  CreditCardWidget({super.key});

  Future<List<double>> getCardData() async {
    double balance = await _firestoreService.getTotalBalance();
    double income = await _firestoreService.getTotalIncome();
    double expenses = await _firestoreService.getTotalExpense();
    return [balance, income, expenses];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
      future: getCardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final data = snapshot.data!;
          return _buildCreditCard(data[0], data[1], data[2]);
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 47, 125, 121),
            ),
          );
        }
      },
    );
  }

  Widget _buildCreditCard(
      double totalBalance, double totalIncome, double totalExpenses) {
    return Container(
      height: 170,
      width: 320,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(47, 125, 121, 0.3),
            offset: Offset(0, 6),
            blurRadius: 12,
            spreadRadius: 6,
          ),
        ],
        color: const Color.fromARGB(255, 47, 125, 121),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              '\$ ${totalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              // Use Expanded to take up remaining vertical space
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    icon: Icons.arrow_downward,
                    label: 'Income',
                    amount: totalIncome,
                    textColor: Colors.white,
                  ),
                  _buildInfoColumn(
                    icon: Icons.arrow_upward,
                    label: 'Expenses',
                    amount: totalExpenses,
                    textColor: totalExpenses > totalIncome
                        ? Colors.red
                        : totalExpenses == totalIncome
                            ? const Color.fromRGBO(239, 108, 0, 1)
                            : Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildInfoColumn({
    required IconData icon,
    required String label,
    required double amount,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: const Color.fromARGB(255, 85, 145, 141),
              child: Icon(
                icon,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 216, 216, 216),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '\$ ${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              // lamda func to return color based on textColor value compared to Colors.red otherwise Colors.white
              color: textColor),
        ),
      ],
    );
  }
}
