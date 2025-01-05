class Expense {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final int userId; // New field

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.userId,
  });

  // Convert Expense to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'user_id': userId, // Include user ID
    };
  }

  // Create Expense from Map (retrieved from the database)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      userId: map['user_id'], // Map user ID
    );
  }
}
