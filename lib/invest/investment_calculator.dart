// lib/pages/investment_calculator_page.dart

import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sakhi/theme/save_theme.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  const InvestmentCalculatorPage({super.key});

  @override
  State<InvestmentCalculatorPage> createState() => _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> with TickerProviderStateMixin {
  final TextEditingController _monthlyInvestmentController = TextEditingController();
  final TextEditingController _annualRateController = TextEditingController();
  final TextEditingController _tenureYearsController = TextEditingController();

  double _maturityAmount = 0.0;
  double _investedAmount = 0.0;
  List<FlSpot> _growthPoints = [];
  bool _showResult = false;
  String _tip = '';
  final ScreenshotController _screenshotController = ScreenshotController();

  late AnimationController _maturityController;
  late Animation<double> _maturityAnimation;

  @override
  void initState() {
    super.initState();
    _maturityController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  void _calculateSIP() {
    FocusScope.of(context).unfocus();

    final double? monthlyInvestment = double.tryParse(_monthlyInvestmentController.text);
    final double? annualRate = double.tryParse(_annualRateController.text);
    final int? tenureYears = int.tryParse(_tenureYearsController.text);

    if (monthlyInvestment == null || monthlyInvestment <= 0 ||
        annualRate == null || annualRate <= 0 ||
        tenureYears == null || tenureYears <= 0) {
      _showSnackBar('Please enter valid inputs for all fields.', error: true);
      setState(() => _showResult = false);
      return;
    }

    final double monthlyRate = (annualRate / 12) / 100;
    final int numberOfInstallments = tenureYears * 12;

    final double fv = monthlyInvestment *
        ((pow(1 + monthlyRate, numberOfInstallments) - 1) / monthlyRate) *
        (1 + monthlyRate);

    // For chart
    List<FlSpot> growth = [];
    double balance = 0;
    for (int i = 0; i < numberOfInstallments; i++) {
      balance += monthlyInvestment * pow(1 + monthlyRate, numberOfInstallments - i);
      growth.add(FlSpot(i.toDouble(), balance));
    }

    _maturityController.reset();
    _maturityAnimation = Tween<double>(begin: 0, end: fv).animate(
      CurvedAnimation(parent: _maturityController, curve: Curves.easeOut),
    )..addListener(() => setState(() {}));
    _maturityController.forward();

    setState(() {
      _investedAmount = monthlyInvestment * numberOfInstallments;
      _maturityAmount = fv;
      _growthPoints = growth;
      _tip = _generateTip(tenureYears, annualRate);
      _showResult = true;
    });

    _showSnackBar('SIP calculation complete!');
  }

  String _generateTip(int years, double rate) {
    if (years >= 10 && rate >= 12) {
      return 'Great! Long-term SIPs with high return rates can build great wealth.';
    } else if (years >= 5) {
      return 'Steady investment builds financial discipline over time.';
    } else {
      return 'Consider increasing tenure or amount for better compounding.';
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

  Future<void> _downloadChart() async {
    try {
      final Uint8List image = await _screenshotController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SIP Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text('Invested Amount: ₹${_investedAmount.toStringAsFixed(2)}'),
                Text('Maturity Amount: ₹${_maturityAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Tip: $_tip'),
              ],
            ),
          ),
        ),
      );

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/sip_summary.png';
      await File(path).writeAsBytes(image);
      await Share.shareXFiles([XFile(path)], text: 'My SIP Projection Summary');
    } catch (_) {
      _showSnackBar("Failed to download chart.", error: true);
    }
  }

  @override
  void dispose() {
    _monthlyInvestmentController.dispose();
    _annualRateController.dispose();
    _tenureYearsController.dispose();
    _maturityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Text('Investment Calculator (SIP)', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInputField(_monthlyInvestmentController, 'Monthly Investment (₹)', FontAwesomeIcons.rupeeSign),
                  const SizedBox(height: 12),
                  _buildInputField(_annualRateController, 'Expected Annual Return Rate (%)', Icons.trending_up_rounded),
                  const SizedBox(height: 12),
                  _buildInputField(_tenureYearsController, 'Investment Tenure (Years)', Icons.timelapse_rounded),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _calculateSIP,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate SIP Returns'),
                  ),
                ],
              ),
            ),
          ),
          if (_showResult) ...[
            const SizedBox(height: 24),
            Text('Your SIP Results', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Screenshot(
              controller: _screenshotController,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildResultRow('Total Invested Amount:', '₹${_investedAmount.toStringAsFixed(2)}', AppTheme.textColor),
                      const Divider(),
                      _buildResultRow('Estimated Maturity Amount:', '₹${_maturityAnimation.value.toStringAsFixed(2)}', AppTheme.primaryColor, isLarge: true),
                      const SizedBox(height: 10),
                      _buildPieChart(),
                      const SizedBox(height: 16),
                      Text('*This is based on compound interest.', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey)),
                      if (_tip.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.tips_and_updates, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_tip, style: Theme.of(context).textTheme.bodyMedium)),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadChart,
                icon: const Icon(Icons.download),
                label: const Text('Download Projection Chart'),
              ),
            ),
            const SizedBox(height: 24),
            if (_growthPoints.isNotEmpty) _buildGrowthChart(),
          ],
          const SizedBox(height: 24),
          Text('Plan your investments, secure your future.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color, {bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: isLarge ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color) : Theme.of(context).textTheme.bodyLarge?.copyWith(color: color))),
          Expanded(flex: 1, child: Text(value, textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color))),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 35,
          sections: [
            PieChartSectionData(value: _investedAmount, color: Colors.orange, title: 'Invested'),
            PieChartSectionData(value: _maturityAmount - _investedAmount, color: Colors.green, title: 'Returns'),
          ],
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('SIP Growth Over Time', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _growthPoints,
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                ],
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
