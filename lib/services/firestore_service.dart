import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/models/income_category.dart';
import 'package:expense_tracker/models/income.dart';

class FirestoreService {
  final String userId; // Add this

  FirestoreService(this.userId); // Modify the constructor to accept UID

  final _firestore = FirebaseFirestore.instance;

  Stream<List<IncomeCategory>> getIncomeCategories() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomeCategories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return IncomeCategory.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<IncomeCategory?> addIncomeCategory(String name) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomeCategories')
        .where('name', isEqualTo: name)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return null;
    }

    final category = IncomeCategory(id: '', name: name);
    DocumentReference docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomeCategories')
        .add(category.toFirestore());

    // Assign the Firestore document ID to the category ID before returning.
    category.id = docRef.id;

    return category;
  }

  Future<void> addIncome(double amount, String categoryId, String description,
      String categoryName) async {
    final income = Income(
      id: '',
      amount: amount,
      categoryId: categoryId,
      description: description,
      categoryName: categoryName,
      date: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .add(income.toFirestore());
  }

  Future<void> deleteIncomeCategory(String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomeCategories')
        .doc(id)
        .delete();
  }

  Future<void> updateIncomeCategory(String trim, String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomeCategories')
        .doc(id)
        .update({'name': trim});
  }

  // edit and delete income
  Stream<List<Income>> getIncomes() {
    // get incomes for a user and populate with category name
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Income.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // funtion to get incomes values only in a list
  Future<List<double>> getIncomesList() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .get();

    List<double> amounts =
        snapshot.docs.map((doc) => (doc['amount'] as num).toDouble()).toList();
    return amounts;
  }

  Future<List<double>> getExpensesList() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();

    List<double> amounts =
        snapshot.docs.map((doc) => (doc['amount'] as num).toDouble()).toList();
    // amounts.sort();
    return amounts;
  }

  Future<void> deleteIncome(String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .doc(id)
        .delete();
  }

  Future<void> updateIncome(String id, double amount, String categoryId,
      String description, String categoryName) {
    final income = Income(
      id: id,
      amount: amount,
      categoryId: categoryId,
      description: description,
      categoryName: categoryName,
      date: DateTime.now(),
    );
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .doc(id)
        .update(income.toFirestore());
  }

  // get total balance using firestore query to sum all incomes for a user
  Future<double> getTotalBalance() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['amount'];
    }
    return total;
  }

  // get total income using firestore query to sum all incomes for a user
  Future<double> getTotalIncome() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['amount'];
    }
    return total;
  }

  // get total expense using firestore query to sum all incomes for a user
  Future<double> getTotalExpense() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();
    double total = 0;
    for (var doc in snapshot.docs) {
      total += doc['amount'];
    }
    return total;
  }

  // function to latest income add
  Future<Income?> getLatestIncome() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('incomes')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Income.fromFirestore(snapshot.docs[0].data(), snapshot.docs[0].id);
  }

  Stream<List<ExpenseCategory>> getExpenseCategories() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseCategory.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<ExpenseCategory?> addExpenseCategory(String name) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .where('name', isEqualTo: name)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return null;
    }

    final category = ExpenseCategory(id: '', name: name);
    DocumentReference docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .add(category.toFirestore());

    // Assign the Firestore document ID to the category ID before returning.
    category.id = docRef.id;

    return category;
  }

  Future<void> addExpense(double amount, String categoryId, String description,
      String categoryName) async {
    final income = Income(
      id: '',
      amount: amount,
      categoryId: categoryId,
      description: description,
      categoryName: categoryName,
      date: DateTime.now(),
    );
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(income.toFirestore());
  }

  Future<void> deleteExpenseCategory(String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .doc(id)
        .delete();
  }

  Future<void> updateExpenseCategory(String trim, String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenseCategories')
        .doc(id)
        .update({'name': trim});
  }

  // edit and delete expense
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deleteExpense(String id) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(id)
        .delete();
  }

  Future<Expense?> getLatestExpense() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Expense.fromFirestore(snapshot.docs[0].data(), snapshot.docs[0].id);
  }

  // update expense function
  Future<void> updateExpense(String id, double amount, String categoryId,
      String description, String categoryName) {
    final expense = Expense(
      id: id,
      amount: amount,
      categoryId: categoryId,
      description: description,
      categoryName: categoryName,
      date: DateTime.now(),
    );
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(id)
        .update(expense.toFirestore());
  }
}
