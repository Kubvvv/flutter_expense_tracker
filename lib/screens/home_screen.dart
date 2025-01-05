import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';
import '../provider/user_provider.dart';
import 'auth/login_screen.dart';
import 'expense/add_expense_screen.dart';
import 'expense/expense_detail_screen.dart';
import 'package:intl/intl.dart';
import 'weather_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  double _totalExpenses = 0.0;

  void _fetchExpenses() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    final expenses = await DatabaseHelper.instance.getExpensesForUser(userId);
    setState(() {
      _expenses = expenses;
      _totalExpenses =
          expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    });
  }

  void _logout() {
    // Clear user state in UserProvider
    Provider.of<UserProvider>(context, listen: false).logout();

    // Navigate back to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(3.14),
          child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ),
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Expenses: \$${_totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(expense.title),
                    subtitle: Text(
                        'Date: ${DateFormat('dd.MM.yyyy, HH:mm').format(DateTime.parse(expense.date))}'),
                    trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseDetailScreen(expense: expense),
                        ),
                      );
                      if (result == true) {
                        _fetchExpenses(); // Refresh the list if an update occurred
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const WeatherWidget(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () {
            final userId =
                Provider.of<UserProvider>(context, listen: false).userId;
            if (userId == null) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(userId: userId),
              ),
            ).then((_) => _fetchExpenses());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
