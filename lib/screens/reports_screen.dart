import 'package:expense_tracker/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportScreen extends StatefulWidget {
  final FirestoreService firestoreService;

  const ReportScreen({Key? key, required this.firestoreService})
      : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  // Segment Control
  int _selectedValue = 0; // 0 for income, 1 for expense

  late final Future<List<double>> _incomes;
  late final Future<List<double>> _expenses;
  double? topIncome;
  double? topExpense;

  // Tab Control
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _incomes = widget.firestoreService.getIncomesList();
    _expenses = widget.firestoreService.getExpensesList();
    fetchTopValues();
  }

  void fetchTopValues() async {
    final incomesList = await widget.firestoreService.getIncomesList();
    final expensesList = await widget.firestoreService.getExpensesList();

    if (incomesList.isNotEmpty) {
      setState(() {
        topIncome =
            incomesList.reduce((curr, next) => curr > next ? curr : next);
      });
    }
    if (expensesList.isNotEmpty) {
      setState(() {
        topExpense =
            expensesList.reduce((curr, next) => curr > next ? curr : next);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: const Color(0xFF429690),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Segment Control for Income and Expense
            Container(
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 156, 222, 216),
                borderRadius: BorderRadius.circular(8.0),
                // make edge softer
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(47, 125, 121, 0.3),
                    offset: Offset(0, 6),
                    blurRadius: 8,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedValue = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: _selectedValue == 0 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: TextStyle(
                                color: _selectedValue == 0
                                    ? const Color(0xFF429690)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedValue = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: _selectedValue == 1 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: TextStyle(
                                color: _selectedValue == 1
                                    ? const Color(0xFF429690)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  _buildLineChart(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Top Income/Expense Indicator
            ListTile(
              title: Text(
                _selectedValue == 0 ? 'Top Income' : 'Top Expense',
                style: const TextStyle(
                    color: Color(0xFF429690), fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_selectedValue == 0
                  ? 'Amount: \$${topIncome ?? 'N/A'}'
                  : 'Amount: \$${topExpense ?? 'N/A'}'), // Updated data
              leading: Icon(
                _selectedValue == 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: const Color(0xFF429690),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> getBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: index % 2 == 0 ? 5.0 + index : 7.0 + index,
            colors: [const Color(0xFF429690)],
          ),
        ],
      );
    });
  }

  Widget _buildLineChart() {
    return FutureBuilder<List<double>>(
      // Decide which future to use based on the segment control value
      future: _selectedValue == 0 ? _incomes : _expenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors that occurred while fetching the data
          return const Center(child: Text("Error fetching data"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle the scenario when there's no data
          return const Center(child: Text("No data available"));
        } else {
          // Convert the data into FlSpot
          List<FlSpot> spots = [];
          for (int i = 0; i < snapshot.data!.length; i++) {
            spots.add(FlSpot(i.toDouble(), snapshot.data![i].toDouble()));
          }

          double maxY =
              snapshot.data!.reduce((curr, next) => curr > next ? curr : next);
          maxY = maxY +
              (maxY *
                  0.15); // Add 15% to the maxY value to show some space at the top
          double maxX = snapshot.data!.length - 1.0;

          return SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFF429690),
                      width: 2,
                    ),
                    left: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    colors: [const Color(0xFF429690)],
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
