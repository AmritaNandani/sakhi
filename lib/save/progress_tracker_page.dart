// lib/pages/progress_tracker_page.dart

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sakhi/theme/save_theme.dart';

class ProgressTrackerPage extends StatefulWidget {
  const ProgressTrackerPage({super.key});

  @override
  State<ProgressTrackerPage> createState() => _ProgressTrackerPageState();
}

class _ProgressTrackerPageState extends State<ProgressTrackerPage> {
  // Mock data for demonstration. In a real app, this would come from a state management solution or backend.
  String _goalName = "My Dream Vacation";
  double _targetAmount = 50000.0;
  double _savedAmount = 15000.0;
  int _durationMonths = 12;

  // Calculate percentage for the progress bar
  double get _progressPercentage {
    if (_targetAmount == 0) return 0.0;
    return (_savedAmount / _targetAmount).clamp(0.0, 1.0);
  }

  // Mock milestones/achievements
  final List<Map<String, dynamic>> _mockMilestones = [
    {'name': 'First ₹1,000 Saved!', 'achieved': true, 'amount': 1000.0},
    {'name': '25% of Goal Achieved!', 'achieved': true, 'amount': 12500.0},
    {'name': 'Halfway There!', 'achieved': false, 'amount': 25000.0},
    {'name': '75% Complete!', 'achieved': false, 'amount': 37500.0},
    {'name': 'Goal Achieved!', 'achieved': false, 'amount': 50000.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Your Savings Progress',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Goal: $_goalName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Target: ₹${_targetAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Saved: ₹${_savedAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 64, // Adjust width based on screen size and padding
                    lineHeight: 24.0,
                    percent: _progressPercentage,
                    backgroundColor: Colors.grey[300],
                    progressColor: AppTheme.accentColor,
                    barRadius: const Radius.circular(12),
                    animation: true,
                    animationDuration: 1000,
                    center: Text(
                      '${(_progressPercentage * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keep going! You are doing great!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Milestones & Achievements',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._mockMilestones.map((milestone) {
            final isAchieved = _savedAmount >= milestone['amount']!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(
                  isAchieved ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isAchieved ? AppTheme.successColor : AppTheme.textColor.withOpacity(0.5),
                  size: 30,
                ),
                title: Text(
                  milestone['name']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    decoration: isAchieved ? TextDecoration.lineThrough : TextDecoration.none,
                    color: isAchieved ? AppTheme.textColor.withOpacity(0.7) : AppTheme.textColor,
                  ),
                ),
                subtitle: Text(
                  'Target: ₹${milestone['amount']!.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: isAchieved
                    ? Icon(Icons.star_rounded, color: AppTheme.accentColor)
                    : null,
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Simulate adding more savings
                setState(() {
                  _savedAmount += 500; // Mock addition
                  if (_savedAmount > _targetAmount) {
                    _savedAmount = _targetAmount; // Cap at target
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('₹500 added to your savings! Current: ₹${_savedAmount.toStringAsFixed(0)}'),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Add Savings (Demo)'),
            ),
          ),
        ],
      ),
    );
  }
}
