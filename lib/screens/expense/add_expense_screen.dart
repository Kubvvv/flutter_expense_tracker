import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/expense.dart';
import '../../services/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  final int userId; // Accept userId as a parameter

  const AddExpenseScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _addExpense() async {
    // Validate input
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Validate numeric input
    try {
      double amount = double.parse(_amountController.text);
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      final expense = Expense(
        title: _titleController.text.trim(),
        amount: amount,
        date: DateTime.now().toIso8601String(),
        userId: widget.userId, // Link the expense to the current user
      );

      await DatabaseHelper.instance.insertExpense(expense);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense Added!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Expense Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExpense,
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
