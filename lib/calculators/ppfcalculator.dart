import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:math' as math;

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color investedColor = Color(0xFFE91E63); // Pink (matches primary in image)
  static const Color interestColor = Color(0xFFFFCC00); // Yellow
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color cyanColor = Color(0xFF00BCD4); // Cyan for PPF
}

// --- Common UI Widgets & Helpers ---

class PieChartPainter extends CustomPainter {
  final double investedAmount;
  final double totalInterest;
  final double strokeWidth;
  final Color investedColor;
  final Color interestColor;

  PieChartPainter({
    required this.investedAmount,
    required this.totalInterest,
    this.strokeWidth = 20.0,
    this.investedColor = AppTheme.investedColor,
    this.interestColor = AppTheme.interestColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = investedAmount + totalInterest;
    final investedSweepAngle = total > 0 ? (investedAmount / total) * 360 * (3.1415926535 / 180) : 0.0;
    final interestSweepAngle = total > 0 ? (totalInterest / total) * 360 * (3.1415926535 / 180) : 0.0;

    final investedPaint = Paint()
      ..color = investedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final interestPaint = Paint()
      ..color = interestColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    if (investedSweepAngle > 0) {
      canvas.drawArc(rect, -90 * (3.1415926535 / 180), investedSweepAngle, false, investedPaint);
    }
    if (interestSweepAngle > 0) {
      canvas.drawArc(rect, (-90 * (3.1415926535 / 180)) + investedSweepAngle, interestSweepAngle, false, interestPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PieChartPainter) {
      return oldDelegate.investedAmount != investedAmount ||
          oldDelegate.totalInterest != totalInterest ||
          oldDelegate.investedColor != investedColor ||
          oldDelegate.interestColor != interestColor;
    }
    return true;
  }
}

Widget buildSliderInput({
  required BuildContext context,
  required String label,
  required double value,
  required double min,
  required double max,
  required int divisions,
  required ValueChanged<double> onChanged,
  required String unit,
  Color accentColor = AppTheme.primaryColor,
  bool hideLabelAbove = false,
  String? minValueLabel,
  String? maxValueLabel,
  bool readOnlyValue = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!hideLabelAbove)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textColor,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                readOnlyValue
                    ? value.toStringAsFixed(1) + unit
                    : (unit == '%' ? '${value.toStringAsFixed(0)} $unit' : '$unit ${value.toStringAsFixed(0)}'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
              ),
            ),
          ],
        ),
      if (!readOnlyValue)
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: accentColor.withOpacity(0.2),
            thumbColor: accentColor,
            overlayColor: accentColor.withOpacity(0.2),
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            trackShape: const RoundedRectSliderTrackShape(), // Ensure this is not null
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: accentColor,
            inactiveTickMarkColor: Colors.white,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: accentColor,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
      if (!readOnlyValue)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minValueLabel ?? '${min.toStringAsFixed(0)} ${unit == 'Yr' ? 'Year' : (unit == 'Months' ? 'Month' : '')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              maxValueLabel ?? '${max.toStringAsFixed(0)} ${unit == 'Yr' ? 'Years' : (unit == 'Months' ? 'Months' : '')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      const SizedBox(height: 16),
    ],
  );
}


Widget buildResultRow({required String label, required String value, Color valueColor = AppTheme.primaryColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: valueColor,
        ),
      ),
    ],
  );
}

Widget buildLegendItem(String text, Color color) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(color: Colors.grey[800], fontSize: 13),
      ),
    ],
  );
}

String formatCurrency(double value) {
  if (value.isNaN || value.isInfinite || value < 0) return '₹ 0';
  return '₹ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}';
}

double customPow(double base, double exponent) {
  if (exponent == 0) return 1.0;
  double result = 1.0;
  for (int i = 0; i < exponent.abs().toInt(); i++) {
    result *= base;
  }
  if (exponent < 0) return 1.0 / result;
  return result;
}

// --- PPF Calculator Page ---
class PPFCalculatorPage extends StatefulWidget {
  const PPFCalculatorPage({super.key});

  @override
  State<PPFCalculatorPage> createState() => _PPFCalculatorPageState();
}

class _PPFCalculatorPageState extends State<PPFCalculatorPage> {
  double _yearlyInvestmentAmount = 10000.0;
  double _rateOfInterest = 7.1; // Fixed as per PPF rules
  double _timePeriodYears = 15.0; // Minimum PPF tenure

  double _maturityValue = 0.0;
  double _amountInvested = 0.0;
  double _estimatedInterest = 0.0;

  @override
  void initState() {
    super.initState();
    _calculatePPF();
  }

  void _calculatePPF() {
    final P = _yearlyInvestmentAmount;
    final r = _rateOfInterest / 100;
    final n = _timePeriodYears;

    if (P <= 0 || r <= 0 || n <= 0) {
      setState(() {
        _maturityValue = 0.0;
        _amountInvested = 0.0;
        _estimatedInterest = 0.0;
      });
      return;
    }

    final futureValue = P * ((customPow(1 + r, n) - 1) / r) * (1 + r);

    _amountInvested = P * n;
    _estimatedInterest = futureValue - _amountInvested;

    setState(() {
      _maturityValue = futureValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPF Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Download Sakhi functionality coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text(
                'Download Sakhi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen = constraints.maxWidth > 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              // FIX: Add ConstrainedBox and IntrinsicHeight here for correct layout
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth, // Ensure it takes at least the screen width
                ),
                child: IntrinsicHeight( // Ensure children fill height in horizontal layout
                  child: Flex(
                    direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (Inputs)
                      Flexible(
                        flex: isLargeScreen ? 3 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // "Did you know?" Section
                            Card(
                              color: AppTheme.sectionBgColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline, color: Colors.orange[800], size: 28),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Don\'t Let Inflation Eat Away Your Wealth — Diversify! Consider investing in equity mutual funds too for long term.',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.orange[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Input Section
                            Card(
                              color: AppTheme.cardColor,
                              elevation: 6,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildSliderInput(
                                      context: context,
                                      label: 'Yearly Investment Amount',
                                      value: _yearlyInvestmentAmount,
                                      min: 500,
                                      max: 150000,
                                      divisions: (150000 - 500) ~/ 500 + 1,
                                      onChanged: (value) {
                                        setState(() {
                                          _yearlyInvestmentAmount = value;
                                        });
                                        _calculatePPF();
                                      },
                                      unit: '₹',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '₹ 500',
                                      maxValueLabel: '₹ 1,50,000',
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'Rate of Interest',
                                      value: _rateOfInterest,
                                      min: _rateOfInterest,
                                      max: _rateOfInterest,
                                      divisions: 1,
                                      onChanged: (value) {},
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                      readOnlyValue: true,
                                      minValueLabel: '',
                                      maxValueLabel: '',
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('PPF interest rates are declared quarterly by the government.'),
                                            backgroundColor: AppTheme.primaryColor,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            margin: const EdgeInsets.all(10),
                                          ),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'Time Period (in years)',
                                      value: _timePeriodYears,
                                      min: 15,
                                      max: 30,
                                      divisions: 15,
                                      onChanged: (value) {
                                        setState(() {
                                          _timePeriodYears = value;
                                        });
                                        _calculatePPF();
                                      },
                                      unit: 'Yr',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '15 Years',
                                      maxValueLabel: '30 Years',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Spacer for large screens
                      if (isLargeScreen) const SizedBox(width: 30),

                      // Right Column (Results)
                      Flexible(
                        flex: isLargeScreen ? 2 : 1,
                        child: isLargeScreen
                            ? Column(children: _buildResultSection(context))
                            : Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Column(children: _buildResultSection(context)),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildResultSection(BuildContext context) {
    return [
      Card(
        color: AppTheme.cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Maturity Value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_maturityValue),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 20),

              if (_amountInvested > 0 || _estimatedInterest > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Amount Invested', AppTheme.investedColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Estimated Interest', AppTheme.interestColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CustomPaint(
                        painter: PieChartPainter(
                          investedAmount: _amountInvested,
                          totalInterest: _estimatedInterest,
                          strokeWidth: 25.0,
                          investedColor: AppTheme.investedColor,
                          interestColor: AppTheme.interestColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),

              buildResultRow(
                label: 'Amount Invested',
                value: formatCurrency(_amountInvested),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Estimated Interest',
                value: formatCurrency(_estimatedInterest),
                valueColor: AppTheme.interestColor,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Download Sakhi functionality coming soon!'),
                        backgroundColor: AppTheme.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Download Sakhi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}