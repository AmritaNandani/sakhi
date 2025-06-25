import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  final List<Map<String, dynamic>> _calculators = const [
    {'name': 'SIP Calculator', 'icon': FontAwesomeIcons.chartLine, 'color': Colors.blueAccent},
    {'name': 'Lumpsum Calculator', 'icon': FontAwesomeIcons.sackDollar, 'color': Colors.green},
    {'name': 'Compound Interest Calculator', 'icon': FontAwesomeIcons.buildingColumns, 'color': Colors.purple},
    {'name': 'Inflation Calculator', 'icon': Icons.trending_down_rounded, 'color': Colors.redAccent},
    {'name': 'Salary Calculator', 'icon': Icons.currency_rupee_rounded, 'color': Colors.teal},
    {'name': 'Home Loan EMI Calculator', 'icon': Icons.home_rounded, 'color': Colors.brown},
    {'name': 'Personal Loan EMI Calculator', 'icon': Icons.person_rounded, 'color': Colors.deepOrange},
    {'name': 'Car Loan EMI Calculator', 'icon': Icons.directions_car_rounded, 'color': Colors.indigo},
    {'name': 'Travel Calculator', 'icon': Icons.card_travel_rounded, 'color': Colors.lightBlue},
    {'name': 'Simple Interest Calculator', 'icon': Icons.money_rounded, 'color': Colors.amber},
    {'name': 'Emergency Fund Calculator', 'icon': Icons.crisis_alert_rounded, 'color': Colors.red},
    {'name': 'Retirement Planning Calculator', 'icon': Icons.elderly_woman_rounded, 'color': Colors.deepPurple},
    {'name': 'PPF Calculator', 'icon': FontAwesomeIcons.bookOpenReader, 'color': Colors.cyan},
    {'name': 'Sukanya Samriddhi Yojana Calculator', 'icon': Icons.girl_rounded, 'color': Colors.pinkAccent},
    {'name': 'Child Education Calculator', 'icon': Icons.child_care_rounded, 'color': Colors.lime},
    {'name': 'Goal Calculator', 'icon': Icons.flag_rounded, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Calculators'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Make Informed Financial Decisions',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    if (constraints.maxWidth > 600) {
                      crossAxisCount = 3;
                    }
                    if (constraints.maxWidth > 900) {
                      crossAxisCount = 4;
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1.1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _calculators.length,
                      itemBuilder: (context, index) {
                        final calculator = _calculators[index];
                        return _buildCalculatorCard(
                          context,
                          calculator['name'],
                          calculator['icon'],
                          calculator['color'],
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Powering your financial insights.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(BuildContext context, String name, IconData icon, Color color) {
    return Card(
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name is coming soon!'),
              backgroundColor: AppTheme.primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: color),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
