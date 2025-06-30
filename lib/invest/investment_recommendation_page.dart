import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
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

  void _getInvestmentRecommendation() async {
    FocusScope.of(context).unfocus();
    final double? amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0 || _selectedRiskLevel == null) {
      _showSnackBar('Please enter a valid amount and select your risk level.', error: true);
      setState(() => _recommendedScheme = null);
      return;
    }

    setState(() {
      _isLoading = true;
      _recommendedScheme = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BACKEND_URL']}/invest/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'riskLevel': _selectedRiskLevel}),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final item = data[0]; // take the first recommendation
          setState(() {
            _recommendedScheme = InvestmentScheme(
              id: item['id'],
              name: item['name'],
              description: item['description'],
              category: item['category'],
              riskLevel: item['riskLevel'],
              typicalReturns: item['typicalReturns'],
              minInvestment: item['minInvestment'],
              lockInPeriod: item['lockInPeriod'],
              taxBenefits: item['taxBenefits'],
              howToStart: item['howToStart'],
              icon: FontAwesomeIcons.chartLine, // default icon
            );
          });
          _showSnackBar('Here\'s a personalized investment recommendation for you!');
        } else {
          _showSnackBar('No recommendations found. Try a different amount.', error: true);
        }
      } else {
        _showSnackBar('Server error: ${response.statusCode}', error: true);
      }
    } catch (e) {
      _showSnackBar('Something went wrong. Please check your internet or try again.', error: true);
    } finally {
      setState(() => _isLoading = false);
    }
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
                          _amountController.text = '500';
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
                    items: ['Low', 'Medium', 'High']
                        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedRiskLevel = value),
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
                    Text('How to Get Started:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_recommendedScheme!.howToStart, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    Text('Projected Growth (Mock Chart):', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
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
                          _showSnackBar('Simulating Investment Roadmap PDF download for ${_recommendedScheme!.name}');
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
          Text('Start your wealth creation journey!', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
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
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            color: highlight ? AppTheme.primaryColor : AppTheme.textColor.withOpacity(0.8),
          )),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            color: highlight ? AppTheme.primaryColor : AppTheme.textColor,
          )),
        ],
      ),
    );
  }
}
