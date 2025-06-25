// lib/pages/goal_setting_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/save/saving_goal.dart';
import 'package:sakhi/theme/save_theme.dart';

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  State<GoalSettingPage> createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  String _dailySavings = '';
  String _weeklySavings = '';
  SavingGoal? _currentGoal;

  void _calculateSavings() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    final String goalName = _goalController.text;
    final double? targetAmount = double.tryParse(_amountController.text);
    final int? durationMonths = int.tryParse(_monthsController.text);

    if (goalName.isEmpty || targetAmount == null || durationMonths == null || targetAmount <= 0 || durationMonths <= 0) {
      _showSnackBar('Please enter valid goal details (Name, Amount, Months).', error: true);
      setState(() {
        _dailySavings = '';
        _weeklySavings = '';
        _currentGoal = null;
      });
      return;
    }

    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + durationMonths, now.day);

    setState(() {
      _currentGoal = SavingGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
        name: goalName,
        targetAmount: targetAmount,
        durationMonths: durationMonths,
        startDate: now,
        endDate: endDate,
      );
      _dailySavings = _currentGoal!.dailyTarget.toStringAsFixed(2);
      _weeklySavings = _currentGoal!.weeklyTarget.toStringAsFixed(2);
    });

    _showSnackBar('Savings plan calculated!', error: false);
  }

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    _amountController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Set Your Savings Goal',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _goalController,
                    decoration: InputDecoration(
                      labelText: 'What do you want to save for?',
                      hintText: 'e.g., New Phone, Child\'s Education',
                      prefixIcon: const Icon(Icons.bookmark_border_rounded, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Target Amount (₹)',
                      hintText: 'e.g., 10000',
                      prefixIcon: const Icon(FontAwesomeIcons.rupeeSign, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duration (in Months)',
                      hintText: 'e.g., 6',
                      prefixIcon: const Icon(Icons.calendar_month_rounded, color: AppTheme.primaryColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Simulate voice input for duration
                          _monthsController.text = '6'; // Example voice input
                          _showSnackBar('Voice input simulated: 6 months');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _calculateSavings,
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('Calculate Savings Plan'),
                  ),
                ],
              ),
            ),
          ),
          if (_currentGoal != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Savings Breakdown for "${_currentGoal!.name}"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(height: 20),
                    _buildSavingsDetailRow(
                      'Target Amount:',
                      '₹${_currentGoal!.targetAmount.toStringAsFixed(2)}',
                    ),
                    _buildSavingsDetailRow(
                      'Duration:',
                      '${_currentGoal!.durationMonths} months',
                    ),
                    _buildSavingsDetailRow(
                      'Start Date:',
                      '${_currentGoal!.startDate.day}/${_currentGoal!.startDate.month}/${_currentGoal!.startDate.year}',
                    ),
                    _buildSavingsDetailRow(
                      'End Date:',
                      '${_currentGoal!.endDate.day}/${_currentGoal!.endDate.month}/${_currentGoal!.endDate.year}',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'To reach ₹${_currentGoal!.targetAmount.toStringAsFixed(0)} in ${_currentGoal!.durationMonths} months, you need to save:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildSavingsDetailRow(
                      'Daily Target:',
                      '₹$_dailySavings',
                      isHighlight: true,
                    ),
                    _buildSavingsDetailRow(
                      'Weekly Target:',
                      '₹$_weeklySavings',
                      isHighlight: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Start your financial independence journey today!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? AppTheme.primaryColor : AppTheme.textColor,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? AppTheme.primaryColor : AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
