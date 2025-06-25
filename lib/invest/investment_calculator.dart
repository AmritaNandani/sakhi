// lib/pages/investment_calculator_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  const InvestmentCalculatorPage({super.key});

  @override
  State<InvestmentCalculatorPage> createState() => _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> {
  final TextEditingController _monthlyInvestmentController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _tenureYearsController = TextEditingController();

  double _maturityAmount = 0.0;
  double _investedAmount = 0.0;
  bool _showResult = false;

  void _calculateSIP() {
    FocusScope.of(context).unfocus();
    final double? monthlyInvestment = double.tryParse(_monthlyInvestmentController.text);
    final double? annualRate = double.tryParse(_annualRateController.text);
    final int? tenureYears = int.tryParse(_tenureYearsController.text);

    if (monthlyInvestment == null || monthlyInvestment <= 0 ||
        annualRate == null || annualRate <= 0 ||
        tenureYears == null || tenureYears <= 0) {
      _showSnackBar('Please enter valid inputs for all fields.', error: true);
      setState(() {
        _showResult = false;
      });
      return;
    }

    // Simple SIP calculation formula (approximate)
    // M = P * ({[1 + i]^n – 1} / i) * (1 + i)
    // Where:
    // M = Maturity amount
    // P = Monthly investment
    // i = Monthly rate of interest (annual rate / 12 / 100)
    // n = Number of installments (tenure in months)

    final double monthlyRate = (annualRate / 12) / 100;
    final int numberOfInstallments = tenureYears * 12;

    double futureValue = 0.0;
    for (int i = 0; i < numberOfInstallments; i++) {
      futureValue += monthlyInvestment * (1 + monthlyRate); // Simple interest for demo
      // For compound interest, a more complex loop or formula would be needed
    }

    // More accurate SIP formula:
    // Future Value = P * (((1 + r)^n - 1) / r) * (1 + r)
    // double futureValueAccurate = monthlyInvestment *
    //     ( ( (pow(1 + monthlyRate, numberOfInstallments) - 1) / monthlyRate) * (1 + monthlyRate) );

    setState(() {
      _investedAmount = monthlyInvestment * numberOfInstallments;
      _maturityAmount = futureValue; // Using simple accumulation for demo
      _showResult = true;
    });

    _showSnackBar('SIP calculation complete!');
  }

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  void dispose() {
    _monthlyInvestmentController.dispose();
    _annualRateController.dispose();
    _tenureYearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Investment Calculator (SIP)',
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
                    controller: _monthlyInvestmentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Monthly Investment (₹)',
                      hintText: 'e.g., 500 or 1000',
                      prefixIcon: const Icon(FontAwesomeIcons.rupeeSign, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _annualRateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Expected Annual Return Rate (%)',
                      hintText: 'e.g., 12 for 12%',
                      prefixIcon: const Icon(Icons.trending_up_rounded, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tenureYearsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Investment Tenure (Years)',
                      hintText: 'e.g., 5 or 10',
                      prefixIcon: const Icon(Icons.timelapse_rounded, color: AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _calculateSIP,
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('Calculate SIP Returns'),
                  ),
                ],
              ),
            ),
          ),
          if (_showResult) ...[
            const SizedBox(height: 24),
            Text(
              'Calculated Returns:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow('Total Invested Amount:', '₹${_investedAmount.toStringAsFixed(2)}', context, AppTheme.textColor),
                    const Divider(height: 20),
                    _buildResultRow('Estimated Maturity Amount:', '₹${_maturityAmount.toStringAsFixed(2)}', context, AppTheme.primaryColor, isLarge: true),
                    const SizedBox(height: 8),
                    Text(
                      '*This is an approximation for demonstration.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Simulating Investment Projection Chart Download...'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                    ),
                  );
                },
                icon: const Icon(Icons.bar_chart_rounded),
                label: const Text('Download Projection Chart'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Plan your investments, secure your future.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, BuildContext context, Color color, {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isLarge
                ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)
                : Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
          ),
          Text(
            value,
            style: isLarge
                ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)
                : Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
