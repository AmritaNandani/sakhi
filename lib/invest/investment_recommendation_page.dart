// lib/pages/investment_recommendation_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/invest/investment_scheme.dart';
import 'package:sakhi/theme/save_theme.dart';

class InvestmentRecommendationPage extends StatefulWidget {
  const InvestmentRecommendationPage({super.key});

  @override
  State<InvestmentRecommendationPage> createState() => _InvestmentRecommendationPageState();
}

class _InvestmentRecommendationPageState extends State<InvestmentRecommendationPage> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedRiskLevel;
  bool _isLoading = false;
  InvestmentScheme? _recommendedScheme;

  // Mock schemes for demonstration (actual data from backend/AI)
  final List<InvestmentScheme> _mockSchemes = [
    InvestmentScheme(
      id: 'ppf',
      name: 'Public Provident Fund (PPF)',
      description: 'A long-term, government-backed savings-cum-tax saving scheme in India.',
      category: 'Government',
      riskLevel: 'Low',
      typicalReturns: '7.1% p.a. (currently)',
      minInvestment: '₹500/year',
      lockInPeriod: '15 years',
      taxBenefits: 'EEE (Exempt, Exempt, Exempt) u/s 80C',
      howToStart: 'Open at Post Office or authorized bank branches.',
      icon: FontAwesomeIcons.buildingColumns,
    ),
    InvestmentScheme(
      id: 'ssy',
      name: 'Sukanya Samriddhi Yojana (SSY)',
      description: 'A small deposit scheme for the girl child, launched under Beti Bachao Beti Padhao.',
      category: 'Government',
      riskLevel: 'Low',
      typicalReturns: '8.2% p.a. (currently)',
      minInvestment: '₹250/year',
      lockInPeriod: 'Until girl is 21 or married after 18',
      taxBenefits: 'EEE (Exempt, Exempt, Exempt) u/s 80C',
      howToStart: 'Open at Post Office or authorized bank branches in the name of a girl child below 10 years.',
      icon: Icons.girl_rounded,
    ),
    InvestmentScheme(
      id: 'digital_gold',
      name: 'Digital Gold',
      description: 'Invest in 24K pure gold digitally without the hassle of physical storage.',
      category: 'Commodity',
      riskLevel: 'Medium',
      typicalReturns: 'Linked to gold price fluctuations',
      minInvestment: '₹100',
      lockInPeriod: 'None (can sell anytime)',
      taxBenefits: 'Taxable as capital gains',
      howToStart: 'Buy through various platforms like Google Pay, Paytm, MMTC-PAMP, etc.',
      icon: FontAwesomeIcons.coins,
    ),
    InvestmentScheme(
      id: 'sip_equity',
      name: 'SIP in Equity Mutual Fund (Growth)',
      description: 'Systematic Investment Plan in equity funds for long-term wealth creation, subject to market risks.',
      category: 'Mutual Fund',
      riskLevel: 'High',
      typicalReturns: '12-15%+ p.a. (historical)',
      minInvestment: '₹500/month',
      lockInPeriod: 'No lock-in, but recommended for >5 years',
      taxBenefits: 'Taxable (LTCG/STCG) unless ELSS',
      howToStart: 'Through a Mutual Fund distributor, bank, or online platforms (e.g., Groww, Zerodha Coin).',
      icon: FontAwesomeIcons.chartLine,
    ),
  ];

  void _getInvestmentRecommendation() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final double? amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0 || _selectedRiskLevel == null) {
      _showSnackBar('Please enter a valid amount and select your risk level.', error: true);
      setState(() {
        _recommendedScheme = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendedScheme = null; // Clear previous recommendation
    });

    // Simulate AI processing and recommendation logic
    Future.delayed(const Duration(seconds: 2), () {
      InvestmentScheme? recommendation;
      if (_selectedRiskLevel == 'Low') {
        if (amount >= 500) {
          recommendation = _mockSchemes.firstWhere((s) => s.id == 'ppf');
        } else {
          recommendation = _mockSchemes.firstWhere((s) => s.id == 'ssy'); // If amount is small
        }
      } else if (_selectedRiskLevel == 'Medium') {
        recommendation = _mockSchemes.firstWhere((s) => s.id == 'digital_gold');
      } else if (_selectedRiskLevel == 'High') {
        recommendation = _mockSchemes.firstWhere((s) => s.id == 'sip_equity');
      }

      setState(() {
        _isLoading = false;
        _recommendedScheme = recommendation;
        if (_recommendedScheme != null) {
          _showSnackBar('Here\'s a personalized investment recommendation for you!', error: false);
        } else {
          _showSnackBar('Could not find a suitable recommendation for now. Try different inputs.', error: true);
        }
      });
    });
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
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Get Your Investment Recommendation',
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
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'How much do you want to invest per month? (₹)',
                      hintText: 'e.g., 500 or 5000',
                      prefixIcon: const Icon(FontAwesomeIcons.rupeeSign, color: AppTheme.primaryColor),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
                        onPressed: () {
                          // Simulate voice input for amount
                          _amountController.text = '500'; // Example
                          _showSnackBar('Voice input simulated: "₹500 per month"');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRiskLevel,
                    decoration: InputDecoration(
                      labelText: 'Your Risk Level',
                      hintText: 'Select your risk preference',
                      prefixIcon: const Icon(Icons.shield_rounded, color: AppTheme.primaryColor),
                    ),
                    items: <String>['Low', 'Medium', 'High']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRiskLevel = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _getInvestmentRecommendation,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.flash_on_rounded),
                    label: Text(_isLoading ? 'Analyzing...' : 'Get Recommendation'),
                  ),
                ],
              ),
            ),
          ),
          if (_recommendedScheme != null) ...[
            const SizedBox(height: 24),
            Text(
              'Your Recommended Investment:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(_recommendedScheme!.icon, color: AppTheme.primaryColor, size: 40),
                      title: Text(
                        _recommendedScheme!.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor),
                      ),
                      subtitle: Text(_recommendedScheme!.description, style: Theme.of(context).textTheme.bodyMedium),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Category:', _recommendedScheme!.category),
                    _buildInfoRow('Risk Level:', _recommendedScheme!.riskLevel),
                    _buildInfoRow('Typical Returns:', _recommendedScheme!.typicalReturns, highlight: true),
                    _buildInfoRow('Min. Investment:', _recommendedScheme!.minInvestment),
                    _buildInfoRow('Lock-in Period:', _recommendedScheme!.lockInPeriod),
                    _buildInfoRow('Tax Benefits:', _recommendedScheme!.taxBenefits),
                    const SizedBox(height: 16),
                    Text(
                      'How to Get Started:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _recommendedScheme!.howToStart,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Projected Growth (Mock Chart):',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    // Placeholder for chart (actual chart generated by backend)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          'Chart showing returns over time will appear here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Simulating Investment Roadmap PDF download for ${_recommendedScheme!.name}...'),
                              backgroundColor: AppTheme.primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.all(10),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Download Investment Roadmap'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Start your wealth creation journey!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppTheme.primaryColor : AppTheme.textColor.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppTheme.primaryColor : AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
