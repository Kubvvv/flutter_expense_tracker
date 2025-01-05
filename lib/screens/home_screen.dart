import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';
import 'auth/login_screen.dart';
import 'expense/add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  double _totalExpenses = 0.0;

  void _fetchExpenses() async {
    final expenses =
        await DatabaseHelper.instance.getExpensesForUser(widget.userId);
    setState(() {
      _expenses = expenses;
      _totalExpenses =
          expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    });
  }

  void _deleteExpense(int expenseId) async {
    await DatabaseHelper.instance
        .deleteExpense(expenseId); // Delete from database
    _fetchExpenses(); // Refresh the list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense deleted!')),
    );
  }

  void _logout() {
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
                    subtitle: Text('Date: ${expense.date}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${expense.amount.toStringAsFixed(2)}'),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () =>
                              _deleteExpense(expense.id!), // Call delete method
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(userId: widget.userId),
            ),
          ).then((_) => _fetchExpenses());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
