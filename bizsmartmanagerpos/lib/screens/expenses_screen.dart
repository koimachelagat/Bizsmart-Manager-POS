import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: const Center(
        child: Text('Expenses coming soon'),
      ),
    );
  }
}