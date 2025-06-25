// lib/pages/income_tracker_page.dart
import 'package:sakhi/theme/save_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class IncomeTrackerPage extends StatelessWidget {
  const IncomeTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Track Your Business Income',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Month\'s Overview (Mock Data)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
                  ),
                  const Divider(height: 20),
                  _buildStatRow(context, 'Total Income:', '₹8,500', Icons.arrow_upward_rounded, AppTheme.successColor),
                  _buildStatRow(context, 'Total Expenses:', '₹2,100', Icons.arrow_downward_rounded, AppTheme.errorColor),
                  _buildStatRow(context, 'Net Profit:', '₹6,400', FontAwesomeIcons.moneyBillWave, AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'Link to Savings Goals:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You earned ₹8,500 this month! Consider allocating a part to your "Emergency Fund" or "Child\'s Education" goal in the SAVE module.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Add Income/Expense functionality coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Add Transaction (Demo)'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Understand your earnings, grow your business.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
