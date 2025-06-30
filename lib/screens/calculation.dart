import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/calculators/compoundinterest.dart' hide AppTheme;
import 'package:sakhi/theme/save_theme.dart'; // Assuming this path is correct for your AppTheme

// Import all standalone calculator pages with their new paths and 'hide AppTheme'
import 'package:sakhi/calculators/SIPCalculator.dart' hide AppTheme; // Assuming SIPCalculator.dart contains SIPCalculatorPage
import 'package:sakhi/calculators/carloan.dart' hide AppTheme; // Assuming carloan.dart contains CarLoanEMICalculatorPage
import 'package:sakhi/calculators/childeducation.dart' hide AppTheme; // Assuming childeducation.dart contains ChildEducationCalculatorPage
import 'package:sakhi/calculators/emergencyfunds.dart' hide AppTheme; // Assuming emergencyfunds.dart contains EmergencyFundCalculatorPage
import 'package:sakhi/calculators/goalcalculator.dart' hide AppTheme; // Assuming goalcalculator.dart contains GoalCalculatorPage
import 'package:sakhi/calculators/homeloan.dart' hide AppTheme; // Assuming homeloan.dart contains HomeLoanEMICalculatorPage
import 'package:sakhi/calculators/inflationcalculator.dart' hide AppTheme; // Assuming inflationcalculator.dart contains InflationCalculatorPage
import 'package:sakhi/calculators/lumpsumCalculator.dart' hide AppTheme; // Assuming lumpsumCalculator.dart contains LumpsumCalculatorPage
import 'package:sakhi/calculators/personalloan.dart' hide AppTheme; // Assuming personalloan.dart contains PersonalLoanEMICalculatorPage
import 'package:sakhi/calculators/ppfcalculator.dart' hide AppTheme; // Assuming ppfcalculator.dart contains PPFCalculatorPage
import 'package:sakhi/calculators/retirementplan.dart' hide AppTheme; // Assuming retirementplan.dart contains RetirementPlanningCalculatorPage
import 'package:sakhi/calculators/salarycalculator.dart' hide AppTheme; // Assuming salarycalculator.dart contains SalaryCalculatorPage
import 'package:sakhi/calculators/simpleinterest.dart' hide AppTheme; // Assuming simpleinterest.dart contains SimpleInterestCalculatorPage
import 'package:sakhi/calculators/sukanya.dart' hide AppTheme; // Assuming sukanya.dart contains SukanyaSamriddhiYojanaCalculatorPage
import 'package:sakhi/calculators/travelcalculator.dart' hide AppTheme; // Assuming travelcalculator.dart contains TravelCalculatorPage
// Note: Compound Interest Calculator page is not yet generated, so its import is commented out
// import 'package:sakhi/calculators/compoundinterest.dart'; // Placeholder for future Compound Interest Calculator

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  final List<Map<String, dynamic>> _calculators = const [
    {'name': 'SIP Calculator', 'icon': FontAwesomeIcons.chartLine, 'color': Colors.blueAccent, 'route': '/sip'},
    {'name': 'Lumpsum Calculator', 'icon': FontAwesomeIcons.sackDollar, 'color': Colors.green, 'route': '/lumpsum'},
    {'name': 'Compound Interest Calculator', 'icon': FontAwesomeIcons.buildingColumns, 'color': Colors.purple, 'route': '/compound_interest'},
    {'name': 'Inflation Calculator', 'icon': Icons.trending_down_rounded, 'color': Colors.redAccent, 'route': '/inflation'},
    {'name': 'Salary Calculator', 'icon': Icons.currency_rupee_rounded, 'color': Colors.teal, 'route': '/salary'},
    {'name': 'Home Loan EMI Calculator', 'icon': Icons.home_rounded, 'color': Colors.brown, 'route': '/home_loan_emi'},
    {'name': 'Personal Loan EMI Calculator', 'icon': Icons.person_rounded, 'color': Colors.deepOrange, 'route': '/personal_loan_emi'},
    {'name': 'Car Loan EMI Calculator', 'icon': Icons.directions_car_rounded, 'color': Colors.indigo, 'route': '/car_loan_emi'},
    {'name': 'Travel Calculator', 'icon': Icons.card_travel_rounded, 'color': Colors.lightBlue, 'route': '/travel'},
    {'name': 'Simple Interest Calculator', 'icon': Icons.money_rounded, 'color': Colors.amber, 'route': '/simple_interest'},
    {'name': 'Emergency Fund Calculator', 'icon': Icons.crisis_alert_rounded, 'color': Colors.red, 'route': '/emergency_fund'},
    {'name': 'Retirement Planning Calculator', 'icon': Icons.elderly_woman_rounded, 'color': Colors.deepPurple, 'route': '/retirement_planning'},
    {'name': 'PPF Calculator', 'icon': FontAwesomeIcons.bookOpenReader, 'color': Colors.cyan, 'route': '/ppf'},
    {'name': 'Sukanya Samriddhi Yojana Calculator', 'icon': Icons.girl_rounded, 'color': Colors.pinkAccent, 'route': '/sukanya_samriddhi'},
    {'name': 'Child Education Calculator', 'icon': Icons.child_care_rounded, 'color': Colors.lime, 'route': '/child_education'},
    {'name': 'Goal Calculator', 'icon': Icons.flag_rounded, 'color': Colors.grey, 'route': '/goal'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Calculators'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      // Adding a SizedBox.shrink() to the floatingActionButton slot to ensure it's laid out.
      floatingActionButton: const SizedBox.shrink(),
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
                          calculator['route'],
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

  Widget _buildCalculatorCard(
      BuildContext context, String name, IconData icon, Color color, String route) {
    return Card(
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to the respective calculator page based on the route
          switch (route) {
            case '/sip':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SIPCalculatorPage()));
              break;
            case '/lumpsum':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LumpsumCalculatorPage()));
              break;
            case '/compound_interest':
              // This calculator page has not been generated yet.
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CompoundInterestCalculatorPage()));
              break;
            case '/inflation':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const InflationCalculatorPage()));
              break;
            case '/salary':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SalaryCalculatorPage()));
              break;
            case '/home_loan_emi':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeLoanEMICalculatorPage()));
              break;
            case '/personal_loan_emi':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalLoanEMICalculatorPage()));
              break;
            case '/car_loan_emi':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CarLoanEMICalculatorPage()));
              break;
            case '/travel':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelCalculatorPage()));
              break;
            case '/simple_interest':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SimpleInterestCalculatorPage()));
              break;
            case '/emergency_fund':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyFundCalculatorPage()));
              break;
            case '/retirement_planning':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RetirementPlanningCalculatorPage()));
              break;
            case '/ppf':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PPFCalculatorPage()));
              break;
            case '/sukanya_samriddhi':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SukanyaSamriddhiYojanaCalculatorPage()));
              break;
            case '/child_education':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChildEducationCalculatorPage()));
              break;
            case '/goal':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GoalCalculatorPage()));
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name is coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(10),
                ),
              );
          }
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
