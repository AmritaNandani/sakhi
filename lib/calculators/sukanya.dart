import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:intl/intl.dart'; // For formatting currency

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  // Specific colors for SSY chart (Pink for Amount Invested, Yellow for Estimated Interest)
  static const Color investedColor = Color(0xFFE91E63); // Pink (matches primary in image)
  static const Color interestColor = Color(0xFFFFCC00); // Yellow
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color pinkAccentColor = Color(0xFFFF4081); // Pink Accent for SSY (as per icon list)
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the circular chart (reused)
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

    // Calculate total for percentage
    final total = investedAmount + totalInterest;

    // Calculate angles
    // Start angle is -90 degrees (top of the circle)
    final investedSweepAngle = total > 0 ? (investedAmount / total) * 360 * (3.1415926535 / 180) : 0.0;
    final interestSweepAngle = total > 0 ? (totalInterest / total) * 360 * (3.1415926535 / 180) : 0.0;

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
      canvas.drawArc(rect, -90 * (3.1415926535 / 180), investedSweepAngle, false, investedPaint);
    }
    if (interestSweepAngle > 0) {
      canvas.drawArc(rect, (-90 * (3.1415926535 / 180)) + investedSweepAngle, interestSweepAngle, false, interestPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PieChartPainter) {
      return oldDelegate.investedAmount != investedAmount || oldDelegate.totalInterest != totalInterest ||
          oldDelegate.investedColor != investedColor || oldDelegate.interestColor != interestColor;
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
  bool hideLabelAbove = false,
  String? minValueLabel,
  String? maxValueLabel,
  bool readOnlyValue = false,
  VoidCallback? onInfoTap, // For info icon next to value
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    readOnlyValue ? value.toStringAsFixed(1) + unit : (unit == '%' ? '${value.toStringAsFixed(0)} $unit' : '$unit ${value.toStringAsFixed(0)}'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                if (onInfoTap != null) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onInfoTap,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      if(!readOnlyValue)
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
      if(!readOnlyValue)
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

// Widget for a customizable number input field (like Start Year / Maturity Year)
class DisplayInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? initialValue;
  final Color? valueBackgroundColor;
  final Color? valueTextColor;
  final bool isReadOnly;

  const DisplayInputField({
    super.key,
    required this.label,
    required this.controller,
    this.initialValue,
    this.valueBackgroundColor,
    this.valueTextColor,
    this.isReadOnly = true, // Default to read-only for display fields
  });

  @override
  Widget build(BuildContext context) {
    // Only update controller text if it's different to avoid unnecessary rebuilds or issues
    if (initialValue != null && controller.text != initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Double check condition inside callback too, in case another update occurred
        if (controller.text != initialValue) {
          controller.text = initialValue!;
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: valueBackgroundColor ?? Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: valueTextColor ?? AppTheme.primaryColor,
                    ),
                    // Ensure text can overflow if needed, though unlikely for single numbers
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for displaying a result row (label and value)
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
      Text(
        text,
        style: TextStyle(color: Colors.grey[800], fontSize: 13),
      ),
    ],
  );
}

// Helper to format currency
String formatCurrency(double value) {
  if (value.isNaN || value.isInfinite || value < 0) return '₹ 0'; // Handle negative values for display
  return '₹ ${NumberFormat('#,##0').format(value)}'; // Use NumberFormat for Indian currency style
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

// --- Sukanya Samriddhi Yojana Calculator Page ---
class SukanyaSamriddhiYojanaCalculatorPage extends StatefulWidget {
  const SukanyaSamriddhiYojanaCalculatorPage({super.key});

  @override
  State<SukanyaSamriddhiYojanaCalculatorPage> createState() => _SukanyaSamriddhiYojanaCalculatorPageState();
}

class _SukanyaSamriddhiYojanaCalculatorPageState extends State<SukanyaSamriddhiYojanaCalculatorPage> {
  // Input Controllers
  double _yearlyInvestmentAmount = 10000.0;
  final TextEditingController _rateOfInterestController = TextEditingController(text: '8.2'); // Fixed for SSY
  final TextEditingController _maturityPeriodController = TextEditingController(text: '21'); // Fixed for SSY
  final TextEditingController _startYearController = TextEditingController(text: DateTime.now().year.toString());
  final TextEditingController _maturityYearController = TextEditingController();

  // Calculated Values
  double _maturityAmount = 0.0;
  double _amountInvested = 0.0;
  double _estimatedInterest = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateSSY(); // Initial calculation
  }

  @override
  void dispose() {
    _rateOfInterestController.dispose();
    _maturityPeriodController.dispose();
    _startYearController.dispose();
    _maturityYearController.dispose();
    super.dispose();
  }

  void _calculateSSY() {
    final P = _yearlyInvestmentAmount; // Yearly investment
    final r = double.tryParse(_rateOfInterestController.text) ?? 0.0;
    final r_decimal = r / 100; // Annual interest rate as decimal

    final maturityPeriodYears = double.tryParse(_maturityPeriodController.text) ?? 0.0;
    final startYear = double.tryParse(_startYearController.text) ?? DateTime.now().year.toDouble();

    if (P <= 0 || r <= 0 || maturityPeriodYears <= 0) {
      setState(() {
        _maturityAmount = 0.0;
        _amountInvested = 0.0;
        _estimatedInterest = 0.0;
        _maturityYearController.text = '';
      });
      return;
    }

    final investmentYears = 15.0; // Deposits for 15 years
    _amountInvested = P * investmentYears;

    double futureValueAfter15Years = 0.0;
    if (r_decimal > 0) {
      // Calculate future value of an annuity for 15 years of investment
      futureValueAfter15Years = P * ((customPow(1 + r_decimal, investmentYears) - 1) / r_decimal) * (1 + r_decimal);
    } else {
      futureValueAfter15Years = P * investmentYears; // Simple sum if rate is 0
    }

    // Compound the amount for the remaining years (21 - 15 = 6 years) without fresh investment
    final remainingCompoundingYears = maturityPeriodYears - investmentYears;
    _maturityAmount = futureValueAfter15Years * customPow(1 + r_decimal, remainingCompoundingYears);

    _estimatedInterest = _maturityAmount - _amountInvested;

    final calculatedMaturityYear = (startYear + maturityPeriodYears).toStringAsFixed(0);
    // Only update if the value is different to avoid unnecessary widget rebuilds
    if (_maturityYearController.text != calculatedMaturityYear) {
      _maturityYearController.text = calculatedMaturityYear;
    }

    setState(() {
      // Rebuild the UI with updated calculated values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sukanya Samriddhi Yojana Calculator'),
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
                    content: const Text('Invest with Sakhi functionality coming soon!'),
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
                'Invest with Sakhi',
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
              child: Flex(
                direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Inputs)
                  isLargeScreen
                      ? Flexible( // Use Flexible when Flex is horizontal (large screen)
                          flex: 3,
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
                                          'A secure future needs both stability and growth—pair your SSY savings with equity mutual funds to achieve both.',
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
                                        min: 250, // Minimum for SSY
                                        max: 150000, // Max for SSY
                                        divisions: (150000 - 250) ~/ 250, // Divisions for 250 increments
                                        onChanged: (value) {
                                          setState(() {
                                            _yearlyInvestmentAmount = value;
                                          });
                                          _calculateSSY(); // Recalculate on slider change
                                        },
                                        unit: '₹',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '₹ 250',
                                        maxValueLabel: '₹ 1,50,000',
                                      ),
                                      const SizedBox(height: 16),

                                      buildSliderInput(
                                        context: context,
                                        label: 'Rate of Interest',
                                        value: _rateOfInterestController.text.isNotEmpty ? double.parse(_rateOfInterestController.text) : 0.0,
                                        min: 0.0,
                                        max: 15.0, // A reasonable max, even if fixed in UI
                                        divisions: 150, // For finer control if it were a slider
                                        onChanged: (value) { /* Fixed, no-op as per SSY rules */ },
                                        unit: '%',
                                        accentColor: AppTheme.primaryColor,
                                        readOnlyValue: true, // Make it read-only for display
                                        onInfoTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('SSY interest rates are declared quarterly by the government.'),
                                              backgroundColor: AppTheme.primaryColor,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              margin: const EdgeInsets.all(10),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      DisplayInputField(
                                        label: 'Maturity Period',
                                        controller: _maturityPeriodController,
                                        initialValue: '${_maturityPeriodController.text} Yr', // Display fixed value
                                        valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                        valueTextColor: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(height: 16),

                                      DisplayInputField(
                                        label: 'Start Year',
                                        controller: _startYearController,
                                        initialValue: _startYearController.text, // Display value from controller
                                        valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                        valueTextColor: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(height: 16),

                                      DisplayInputField(
                                        label: 'Maturity Year',
                                        controller: _maturityYearController,
                                        valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                        valueTextColor: AppTheme.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column( // Do NOT use Flexible when Flex is vertical (small screen)
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
                                        'A secure future needs both stability and growth—pair your SSY savings with equity mutual funds to achieve both.',
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
                                      min: 250, // Minimum for SSY
                                      max: 150000, // Max for SSY
                                      divisions: (150000 - 250) ~/ 250, // Divisions for 250 increments
                                      onChanged: (value) {
                                        setState(() {
                                          _yearlyInvestmentAmount = value;
                                        });
                                        _calculateSSY(); // Recalculate on slider change
                                      },
                                      unit: '₹',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '₹ 250',
                                      maxValueLabel: '₹ 1,50,000',
                                    ),
                                    const SizedBox(height: 16),

                                    buildSliderInput(
                                      context: context,
                                      label: 'Rate of Interest',
                                      value: _rateOfInterestController.text.isNotEmpty ? double.parse(_rateOfInterestController.text) : 0.0,
                                      min: 0.0,
                                      max: 15.0, // A reasonable max, even if fixed in UI
                                      divisions: 150, // For finer control if it were a slider
                                      onChanged: (value) { /* Fixed, no-op as per SSY rules */ },
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                      readOnlyValue: true, // Make it read-only for display
                                      onInfoTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('SSY interest rates are declared quarterly by the government.'),
                                            backgroundColor: AppTheme.primaryColor,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            margin: const EdgeInsets.all(10),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    DisplayInputField(
                                      label: 'Maturity Period',
                                      controller: _maturityPeriodController,
                                      initialValue: '${_maturityPeriodController.text} Yr', // Display fixed value
                                      valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                      valueTextColor: AppTheme.primaryColor,
                                    ),
                                    const SizedBox(height: 16),

                                    DisplayInputField(
                                      label: 'Start Year',
                                      controller: _startYearController,
                                      initialValue: _startYearController.text, // Display value from controller
                                      valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                      valueTextColor: AppTheme.primaryColor,
                                    ),
                                    const SizedBox(height: 16),

                                    DisplayInputField(
                                      label: 'Maturity Year',
                                      controller: _maturityYearController,
                                      valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                      valueTextColor: AppTheme.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                  // Spacer for large screens
                  if (isLargeScreen) const SizedBox(width: 30),

                  // Right Column (Results)
                  isLargeScreen
                      ? Flexible( // Use Flexible when Flex is horizontal (large screen)
                          flex: 2,
                          child: Column(children: _buildResultSection(context)),
                        )
                      : Padding( // Apply padding and do NOT use Flexible when Flex is vertical (small screen)
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(children: _buildResultSection(context)),
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
                'Maturity Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_maturityAmount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor, // Use primary color for main result
                ),
              ),
              const SizedBox(height: 20),

              // Chart and Legend
              // Ensure chart only renders if values are valid to avoid division by zero in painter
              if (_amountInvested > 0 || _estimatedInterest > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Amount Invested', AppTheme.investedColor), // Pink
                        const SizedBox(width: 20),
                        buildLegendItem('Estimated Interest', AppTheme.interestColor), // Yellow
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150, // Fixed width for the chart
                      height: 150, // Fixed height for the chart
                      child: CustomPaint(
                        painter: PieChartPainter(
                          investedAmount: _amountInvested,
                          totalInterest: _estimatedInterest,
                          strokeWidth: 25.0,
                          investedColor: AppTheme.investedColor, // Pink
                          interestColor: AppTheme.interestColor, // Yellow
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
                valueColor: AppTheme.investedColor, // Pink from image
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Estimated Interest',
                value: formatCurrency(_estimatedInterest),
                valueColor: AppTheme.interestColor, // Yellow from image
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invest with Sakhi functionality coming soon!'),
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
                    'Invest with Sakhi',
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