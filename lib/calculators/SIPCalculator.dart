import 'package:flutter/material.dart';
// If you use Font Awesome, uncomment the line below and ensure the package is in pubspec.yaml
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- App Theme Definition (Copied from app_theme.dart) ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from image
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(
    0xFFFFF2D9,
  ); // Light yellow for "Did you know?"
  static const Color investedColor = Color(
    0xFFFFCC00,
  ); // Yellow for invested amount in chart
  static const Color interestColor = Color(
    0xFFE91E63,
  ); // Pink for interest in chart (Estimated Returns)
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
}

// --- Common UI Widgets & Helpers (Copied from common_calculator_ui.dart) ---

// Custom Painter for drawing the circular chart (reusable)
class PieChartPainter extends CustomPainter {
  final double investedAmount;
  final double totalInterest; // This now represents "estimated returns"
  final double strokeWidth;
  final Color investedColor;
  final Color interestColor; // This now represents "estimated returns" color

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

    // Calculate total for percentage
    final total = investedAmount + totalInterest;

    // Calculate angles
    // Start angle is -90 degrees (top of the circle)
    final investedSweepAngle = total > 0
        ? (investedAmount / total) * 360 * (3.1415926535 / 180)
        : 0.0;
    final interestSweepAngle = total > 0
        ? (totalInterest / total) * 360 * (3.1415926535 / 180)
        : 0.0;

    // Paint for invested amount
    final investedPaint = Paint()
      ..color = investedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Paint for total interest/estimated returns
    final interestPaint = Paint()
      ..color = interestColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Draw arcs
    if (investedSweepAngle > 0) {
      canvas.drawArc(
        rect,
        -90 * (3.1415926535 / 180),
        investedSweepAngle,
        false,
        investedPaint,
      );
    }
    if (interestSweepAngle > 0) {
      canvas.drawArc(
        rect,
        (-90 * (3.1415926535 / 180)) + investedSweepAngle,
        interestSweepAngle,
        false,
        interestPaint,
      );
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

// Widget for a customizable slider input
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
  bool hideLabelAbove =
      false, // New parameter to hide label if it's already provided outside
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!hideLabelAbove) // Only show label if not hidden
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppTheme.textColor),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                unit == '%'
                    ? '${value.toStringAsFixed(0)} $unit'
                    : '$unit ${value.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: accentColor,
          inactiveTrackColor: accentColor.withOpacity(0.2),
          thumbColor: accentColor,
          overlayColor: accentColor.withOpacity(0.2),
          trackHeight: 6.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            unit == 'Yr' || unit == 'Months'
                ? '${min.toStringAsFixed(0)} ${unit == 'Yr' ? 'Year' : 'Month'}'
                : min.toStringAsFixed(0),
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            unit == 'Yr' || unit == 'Months'
                ? '${max.toStringAsFixed(0)} ${unit == 'Yr' ? 'Years' : 'Months'}'
                : (unit == '₹'
                      ? '₹ ${max.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}'
                      : max.toStringAsFixed(0)),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}

// Widget for displaying a result row (label and value)
Widget buildResultRow({
  required String label,
  required String value,
  Color valueColor = AppTheme.primaryColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
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

// Widget for a legend item in the chart
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
      Text(text, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
    ],
  );
}

// Helper to format currency
String formatCurrency(double value) {
  if (value.isNaN || value.isInfinite) return '₹ 0';
  return '₹ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}';
}

// Helper to calculate power, as `dart:math` is not implicitly available in sandbox
double customPow(double base, double exponent) {
  if (exponent == 0) return 1.0;
  // A simple loop-based power for positive integer exponents.
  // For production, consider using `math.pow` from 'dart:math' or a more robust library.
  double result = 1.0;
  for (int i = 0; i < exponent.abs().toInt(); i++) {
    result *= base;
  }
  if (exponent < 0) return 1.0 / result;
  return result;
}

// --- SIP Calculator Page (Combined) ---
class SIPCalculatorPage extends StatefulWidget {
  const SIPCalculatorPage({super.key});

  @override
  State<SIPCalculatorPage> createState() => _SIPCalculatorPageState();
}

class _SIPCalculatorPageState extends State<SIPCalculatorPage> {
  double _monthlyInvestment = 15000.0;
  double _expectedReturnRate = 12.0;
  double _tenureValue =
      10.0; // Represents years or months based on _isYearsSelected
  bool _isYearsSelected = true; // true for years, false for months

  double _maturityAmount = 0.0;
  double _totalInvestment = 0.0;
  double _estimatedReturns =
      0.0; // Changed from totalInterest to estimatedReturns

  @override
  void initState() {
    super.initState();
    _calculateSIP(); // Calculate initial values
  }

  void _calculateSIP() {
    final p = _monthlyInvestment;
    final r = _expectedReturnRate / 100 / 12; // Monthly rate
    double n; // Total number of installments (in months)

    if (_isYearsSelected) {
      n = _tenureValue * 12; // Convert years to months
    } else {
      n = _tenureValue; // Already in months
    }

    if (p <= 0 || r <= 0 || n <= 0) {
      setState(() {
        _maturityAmount = 0.0;
        _totalInvestment = 0.0;
        _estimatedReturns = 0.0;
      });
      return;
    }

    // Formula for Future Value of a series of payments (SIP) - End of period investment
    // FV = P * (((1 + r)^n - 1) / r) * (1 + r)
    // For Sandbox compatibility, using customPow
    final futureValue = p * ((customPow(1 + r, n) - 1) / r) * (1 + r);
    final totalInvested = p * n;
    final estimatedReturns = futureValue - totalInvested;

    setState(() {
      _maturityAmount = futureValue;
      _totalInvestment = totalInvested;
      _estimatedReturns = estimatedReturns;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the max divisions for the time period slider based on selected unit
    int tenureDivisions = _isYearsSelected
        ? 49
        : 599; // 1-50 years (49 divisions), 1-600 months (599 divisions)
    double tenureMax = _isYearsSelected
        ? 50.0
        : 600.0; // Max years or max months
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor, // Pink color from the image
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Invest Now functionality coming soon!',
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Invest Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen =
                constraints.maxWidth >
                700; // Define a breakpoint for large screens

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Flex(
                direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Inputs)
                  Container(
                    width: isLargeScreen ? constraints.maxWidth * 0.6 : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // "Did you know?" Section
                        Card(
                          color: AppTheme.sectionBgColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.orange[800],
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'SIPing is not just for beverages - it\'s for building financial empires too!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildSliderInput(
                                  context: context,
                                  label:
                                      'What is your monthly investment amount?',
                                  value: _monthlyInvestment,
                                  min: 100,
                                  max:
                                      1000000, // Max for monthly investment up to 10 lakhs
                                  divisions:
                                      (1000000 - 100) ~/ 100 +
                                      1, // Divisions for ₹100 increments
                                  onChanged: (value) {
                                    setState(() {
                                      _monthlyInvestment = value;
                                    });
                                    _calculateSIP();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.primaryColor,
                                ),
                                const SizedBox(height: 16),

                                Text(
                                  'What is the time period?',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(color: AppTheme.textColor),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(
                                    4,
                                  ), // Padding inside the toggle container
                                  child: ToggleButtons(
                                    isSelected: [
                                      _isYearsSelected,
                                      !_isYearsSelected,
                                    ],
                                    onPressed: (int index) {
                                      setState(() {
                                        _isYearsSelected = index == 0;
                                        // Reset _tenureValue when switching units to stay within reasonable ranges
                                        if (_isYearsSelected) {
                                          _tenureValue = 10.0; // Default years
                                        } else {
                                          _tenureValue =
                                              120.0; // Default months (10 years)
                                        }
                                      });
                                      _calculateSIP();
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    selectedColor: Colors.white,
                                    fillColor: AppTheme.primaryColor,
                                    color: AppTheme.textColor,
                                    splashColor: AppTheme.primaryColor
                                        .withOpacity(0.2),
                                    highlightColor: AppTheme.primaryColor
                                        .withOpacity(0.1),
                                    borderColor:
                                        Colors.transparent, // No border
                                    selectedBorderColor:
                                        Colors.transparent, // No border
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: const <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        child: Text('Years'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        child: Text('Months'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildSliderInput(
                                  context: context,
                                  label:
                                      '', // Label handled by "What is the time period?"
                                  value: _tenureValue,
                                  min: 1.0,
                                  max: tenureMax,
                                  divisions: tenureDivisions,
                                  onChanged: (value) {
                                    setState(() {
                                      _tenureValue = value;
                                    });
                                    _calculateSIP();
                                  },
                                  unit: tenureUnit,
                                  accentColor: AppTheme.primaryColor,
                                  hideLabelAbove:
                                      true, // Hide the label as it's provided outside
                                ),
                                const SizedBox(height: 16),

                                buildSliderInput(
                                  context: context,
                                  label: 'Expected rate of return',
                                  value: _expectedReturnRate,
                                  min: 1,
                                  max: 30,
                                  divisions: 29,
                                  onChanged: (value) {
                                    setState(() {
                                      _expectedReturnRate = value;
                                    });
                                    _calculateSIP();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.primaryColor,
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
                  Container(
                    width: isLargeScreen ? constraints.maxWidth * 0.4 : null,
                    child: isLargeScreen
                        ? Column(children: _buildResultSection(context))
                        : Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              children: _buildResultSection(context),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build the result section, reusable for responsive layout
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
                'Total value',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_maturityAmount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              // Chart and Legend
              if (_monthlyInvestment > 0 &&
                  (_totalInvestment > 0 || _estimatedReturns > 0))
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem(
                          'Invested Amount',
                          AppTheme.investedColor,
                        ),
                        const SizedBox(width: 20),
                        buildLegendItem(
                          'Estimated Returns',
                          AppTheme.interestColor,
                        ), // Using interestColor as it's pink
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150, // Fixed size for the chart
                      height: 150,
                      child: CustomPaint(
                        painter: PieChartPainter(
                          investedAmount: _totalInvestment,
                          totalInterest:
                              _estimatedReturns, // Pass estimated returns as totalInterest to painter
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
                label: 'Invested amount',
                value: formatCurrency(_totalInvestment),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Estimated returns',
                value: formatCurrency(_estimatedReturns),
                valueColor: AppTheme
                    .interestColor, // Use interestColor for estimated returns
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Invest Now functionality coming soon!',
                        ),
                        backgroundColor: AppTheme.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                    'Invest Now',
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
