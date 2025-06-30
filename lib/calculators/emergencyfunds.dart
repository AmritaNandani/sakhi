import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// If you use Font Awesome, uncomment the line below and ensure the package is in pubspec.yaml
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// For mathematical operations like pow, you might need to import dart:math
// import 'dart:math' as math; // Not strictly needed for customPow

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color investedColor = Color(0xFFFFCC00); // Yellow for bar in chart (Monthly Expenses)
  static const Color interestColor = Color(0xFFE91E63); // Pink for bar in chart (Required Emergency Fund)
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color redColor = Color(0xFFF44336); // Red for Emergency Fund (as per icon)
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the Bar Chart
class BarChartPainter extends CustomPainter {
  final double monthlyExpenses;
  final double requiredEmergencyFund;
  final Color monthlyExpensesColor;
  final Color requiredEmergencyFundColor;

  BarChartPainter({
    required this.monthlyExpenses,
    required this.requiredEmergencyFund,
    this.monthlyExpensesColor = AppTheme.investedColor, // Yellow
    this.requiredEmergencyFundColor = AppTheme.primaryColor, // Pink
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = 40.0; // Width of each bar
    final double spacing = 40.0; // Space between bars
    final double baseLineY = size.height; // Bottom of the chart

    // Find the maximum value to scale the bars
    final double maxValue = requiredEmergencyFund > monthlyExpenses ? requiredEmergencyFund : monthlyExpenses;
    if (maxValue == 0) return; // Avoid division by zero

    // Scale factor to fit bars within the canvas height
    final double scaleFactor = (size.height - 20) / maxValue; // -20 for a small top margin

    // Paint for Monthly Expenses bar
    final monthlyExpensesPaint = Paint()..color = monthlyExpensesColor;
    // Paint for Required Emergency Fund bar
    final requiredEmergencyFundPaint = Paint()..color = requiredEmergencyFundColor;

    // Draw Monthly Expenses bar
    final double monthlyExpensesBarHeight = monthlyExpenses * scaleFactor;
    final double monthlyExpensesBarLeft = (size.width / 2) - barWidth - (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(monthlyExpensesBarLeft, baseLineY - monthlyExpensesBarHeight, barWidth, monthlyExpensesBarHeight),
        const Radius.circular(5), // Rounded top corners
      ),
      monthlyExpensesPaint,
    );

    // Draw Required Emergency Fund bar
    final double requiredEmergencyFundBarHeight = requiredEmergencyFund * scaleFactor;
    final double requiredEmergencyFundBarLeft = (size.width / 2) + (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(requiredEmergencyFundBarLeft, baseLineY - requiredEmergencyFundBarHeight, barWidth, requiredEmergencyFundBarHeight),
        const Radius.circular(5), // Rounded top corners
      ),
      requiredEmergencyFundPaint,
    );

    // Drawing Y-axis labels (optional, simplified)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    final List<double> yAxisValues = [0, maxValue * 0.25, maxValue * 0.5, maxValue * 0.75, maxValue];
    for (var val in yAxisValues) {
      final yPos = baseLineY - (val * scaleFactor);
      textPainter.text = TextSpan(
        text: formatCurrency(val),
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width - 5, yPos - textPainter.height / 2)); // 5 for padding
    }

    // Drawing X-axis labels below bars
    textPainter.text = const TextSpan(
      text: 'Monthly Expenses',
      style: TextStyle(color: AppTheme.textColor, fontSize: 11, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(monthlyExpensesBarLeft + (barWidth / 2) - (textPainter.width / 2), baseLineY + 5));

    textPainter.text = const TextSpan(
      text: 'Required Emergency Fund',
      style: TextStyle(color: AppTheme.textColor, fontSize: 11, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(requiredEmergencyFundBarLeft + (barWidth / 2) - (textPainter.width / 2), baseLineY + 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BarChartPainter) {
      return oldDelegate.monthlyExpenses != monthlyExpenses || oldDelegate.requiredEmergencyFund != requiredEmergencyFund;
    }
    return true;
  }
}

// Helper to format currency
String formatCurrency(double value) {
  if (value.isNaN || value.isInfinite || value < 0) return '₹ 0';
  return '₹ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}';
}

// Helper to calculate power, as `dart:math` is not implicitly available in sandbox
double customPow(double base, double exponent) {
  if (exponent == 0) return 1.0;
  double result = 1.0;
  for (int i = 0; i < exponent.abs().toInt(); i++) {
    result *= base;
  }
  if (exponent < 0) return 1.0 / result;
  return result;
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
  bool hideLabelAbove = false,
  String? minValueLabel,
  String? maxValueLabel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!hideLabelAbove)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FIX: Wrap label with Expanded to prevent overflow
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textColor,
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                unit == '%' ? '${value.toStringAsFixed(0)} $unit' : '$unit ${value.toStringAsFixed(0)}',
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
          // These labels are usually short, but good to be mindful.
          Text(
            minValueLabel ?? '${min.toStringAsFixed(0)}${unit == 'Mn' ? ' Month' : ''}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            maxValueLabel ?? '${max.toStringAsFixed(0)}${unit == 'Mn' ? ' Months' : ''}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ],
  );
}

// Widget for displaying a result row (label and value)
Widget buildResultRow({required String label, required String value, Color valueColor = AppTheme.primaryColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // FIX: Wrap label with Expanded to prevent overflow
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
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
      // Text here is usually short, so Expanded might not be strictly needed,
      // but if legend items get very long, it could be useful.
      Text(
        text,
        style: TextStyle(color: Colors.grey[800], fontSize: 13),
      ),
    ],
  );
}

// --- Emergency Fund Calculator Page ---
class EmergencyFundCalculatorPage extends StatefulWidget {
  const EmergencyFundCalculatorPage({super.key});

  @override
  State<EmergencyFundCalculatorPage> createState() => _EmergencyFundCalculatorPageState();
}

class _EmergencyFundCalculatorPageState extends State<EmergencyFundCalculatorPage> {
  double _monthlyExpenses = 30000.0;
  double _monthsToBuildFundFor = 6.0; // How many months coverage
  double _expectedReturnRate = 6.0; // Annual expected return rate
  double _monthsToBuildThisFund = 24.0; // In how many months do you want to build this fund (for SIP/Lumpsum)

  double _requiredEmergencyFund = 0.0;
  double _requiredSIP = 0.0;
  double _requiredLumpsum = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateEmergencyFund();
  }

  void _calculateEmergencyFund() {
    // 1. Required Emergency Fund
    _requiredEmergencyFund = _monthlyExpenses * _monthsToBuildFundFor;

    // 2. Required SIP
    final FV_sip = _requiredEmergencyFund;
    final r_monthly_sip = _expectedReturnRate / 100 / 12;
    final n_months_sip = _monthsToBuildThisFund;

    if (FV_sip > 0 && r_monthly_sip > 0 && n_months_sip > 0) {
      final term_sip = (customPow(1 + r_monthly_sip, n_months_sip) - 1) / r_monthly_sip;
      // Added a check to prevent division by zero for term_sip
      _requiredSIP = term_sip != 0 ? FV_sip / (term_sip * (1 + r_monthly_sip)) : 0.0;
    } else {
      _requiredSIP = 0.0;
    }

    // 3. Required Lumpsum
    final FV_lumpsum = _requiredEmergencyFund;
    final r_annual_lumpsum = _expectedReturnRate / 100;
    final t_years_lumpsum = _monthsToBuildThisFund / 12;

    if (FV_lumpsum > 0 && r_annual_lumpsum > 0 && t_years_lumpsum > 0) {
      final denominator = customPow(1 + r_annual_lumpsum, t_years_lumpsum);
      // Added a check to prevent division by zero for denominator
      _requiredLumpsum = denominator != 0 ? FV_lumpsum / denominator : 0.0;
    } else {
      _requiredLumpsum = 0.0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Fund Calculator'),
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
                    content: const Text('Invest Now functionality coming soon!'),
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
            bool isLargeScreen = constraints.maxWidth > 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40, // Account for padding
                  maxHeight: isLargeScreen ? constraints.maxHeight - 40 : double.infinity,
                ),
                child: IntrinsicHeight(
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
                                    // Use Expanded for the text to ensure it wraps
                                    Expanded(
                                      child: Text(
                                        'Emergency Fund: Cushion for Life\'s Storms.',
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
                                      label: 'What is your monthly expenses?',
                                      value: _monthlyExpenses,
                                      min: 100,
                                      max: 100000,
                                      divisions: (100000 - 100) ~/ 100 + 1,
                                      onChanged: (value) {
                                        setState(() {
                                          _monthlyExpenses = value;
                                        });
                                        _calculateEmergencyFund();
                                      },
                                      unit: '₹',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '₹ 100',
                                      maxValueLabel: '₹ 1,00,000',
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'Expected rate of return',
                                      value: _expectedReturnRate,
                                      min: 2,
                                      max: 8,
                                      divisions: 6,
                                      onChanged: (value) {
                                        setState(() {
                                          _expectedReturnRate = value;
                                        });
                                        _calculateEmergencyFund();
                                      },
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '2%',
                                      maxValueLabel: '8%',
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'How many months do you want to build an Emergency Fund for?',
                                      value: _monthsToBuildFundFor,
                                      min: 1,
                                      max: 36,
                                      divisions: 35,
                                      onChanged: (value) {
                                        setState(() {
                                          _monthsToBuildFundFor = value;
                                        });
                                        _calculateEmergencyFund();
                                      },
                                      unit: 'Mn',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '1 Month',
                                      maxValueLabel: '36 Months',
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'In how many months, do you want to build this fund?',
                                      value: _monthsToBuildThisFund,
                                      min: 1,
                                      max: 36,
                                      divisions: 35,
                                      onChanged: (value) {
                                        setState(() {
                                          _monthsToBuildThisFund = value;
                                        });
                                        _calculateEmergencyFund();
                                      },
                                      unit: 'Mn',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '1 Month',
                                      maxValueLabel: '36 Months',
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
                'Required emergency fund',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_requiredEmergencyFund),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 20),

              if (_requiredEmergencyFund > 0 || _monthlyExpenses > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // These are generally short, but good practice to consider flex if needed
                        buildLegendItem('Monthly Expenses', AppTheme.investedColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Required Emergency Fund', AppTheme.primaryColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // FIX: Changed fixed width to double.infinity to fill available space
                    SizedBox(
                      width: double.infinity, // Changed from 200
                      height: 150,
                      child: CustomPaint(
                        painter: BarChartPainter(
                          monthlyExpenses: _monthlyExpenses,
                          requiredEmergencyFund: _requiredEmergencyFund,
                          monthlyExpensesColor: AppTheme.investedColor,
                          requiredEmergencyFundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),

              buildResultRow(
                label: 'Required SIP',
                value: formatCurrency(_requiredSIP),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required Lumpsum',
                value: formatCurrency(_requiredLumpsum),
                valueColor: AppTheme.interestColor,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invest Now functionality coming soon!'),
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