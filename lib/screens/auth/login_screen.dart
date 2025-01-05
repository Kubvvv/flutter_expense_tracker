import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../services/database_helper.dart';
import '../../provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToRegister() {
    // Clear inputs before navigating to Register Screen
    _usernameController.clear();
    _passwordController.clear();

    // Navigate to Register Screen
    Navigator.pushNamed(context, '/register');
  }

  void _loginUser() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        _usernameController.text.trim(),
        _passwordController.text.trim()
      ],
    );

    if (result.isNotEmpty) {
      final userId = result.first['id'] as int;
      final username = result.first['username'] as String;

      // Update UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.login(userId, username);

      // Navigate to HomeScreen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _navigateToRegister,
              child: Text(
                "Don't have an account? Register here",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
