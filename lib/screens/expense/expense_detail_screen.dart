import 'package:flutter/material.dart';
import '../../models/expense.dart';
import '../../services/database_helper.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({Key? key, required this.expense})
      : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
  }

  void _updateExpense() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      double amount = double.parse(_amountController.text);
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      final updatedExpense = Expense(
        id: widget.expense.id,
        title: _titleController.text.trim(),
        amount: amount,
        date: widget.expense.date,
        userId: widget.expense.userId,
      );

      await DatabaseHelper.instance.updateExpense(updatedExpense);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense updated!')),
      );
      Navigator.pop(
          context, true); // Return true to indicate an update occurred
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  void _deleteExpense() async {
    await DatabaseHelper.instance
        .deleteExpense(widget.expense.id!); // Delete the expense
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense deleted!')),
    );
    Navigator.pop(context, true); // Return true to indicate deletion occurred
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Delete'),
                  content:
                      Text('Are you sure you want to delete this expense?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // Cancel
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true), // Confirm
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                _deleteExpense();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateExpense,
              child: Text('Update Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
