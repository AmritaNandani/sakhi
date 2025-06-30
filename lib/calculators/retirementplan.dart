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
  static const Color expensesNowColor = Color(0xFFFFCC00); // Yellow
  static const Color expensesThenColor = Color(0xFFE91E63); // Pink
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color deepPurpleColor = Color(0xFF673AB7); // Deep Purple for Retirement (as per icon)
}

// --- Common UI Widgets & Helpers ---

class BarChartPainter extends CustomPainter {
  final double value1;
  final double value2;
  final Color value1Color;
  final Color value2Color;
  final String label1;
  final String label2;

  BarChartPainter({
    required this.value1,
    required this.value2,
    required this.label1,
    required this.label2,
    this.value1Color = AppTheme.expensesNowColor,
    this.value2Color = AppTheme.expensesThenColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = 40.0;
    final double spacing = 40.0;
    final double baseLineY = size.height - 20;

    final double maxValue = (value1 > value2 ? value1 : value2) * 1.2;
    if (maxValue == 0) return;

    final double scaleFactor = (size.height - 40) / maxValue;

    final paint1 = Paint()..color = value1Color;
    final paint2 = Paint()..color = value2Color;

    final double bar1Height = value1 * scaleFactor;
    final double bar1Left = (size.width / 2) - barWidth - (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar1Left, baseLineY - bar1Height, barWidth, bar1Height),
        const Radius.circular(5),
      ),
      paint1,
    );

    final double bar2Height = value2 * scaleFactor;
    final double bar2Left = (size.width / 2) + (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar2Left, baseLineY - bar2Height, barWidth, bar2Height),
        const Radius.circular(5),
      ),
      paint2,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    // Only draw Y-axis labels if maxValue is large enough to show distinct steps
    final List<double> yAxisValues = [0, maxValue * 0.25, maxValue * 0.5, maxValue * 0.75, maxValue * 0.9];
    for (var val in yAxisValues) {
      if (val > 0.1 * maxValue || val == 0) { // Avoid drawing too many small labels
        final yPos = baseLineY - (val * scaleFactor);
        textPainter.text = TextSpan(
          text: formatCurrency(val),
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        );
        textPainter.layout();
        // Adjust x-position to align to the right of the y-axis
        textPainter.paint(canvas, Offset(size.width * 0.1 - textPainter.width - 5, yPos - textPainter.height / 2));
      }
    }

    // Draw X-axis labels (below the bars)
    textPainter.text = TextSpan(
      text: label1,
      style: const TextStyle(color: AppTheme.textColor, fontSize: 11, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(bar1Left + (barWidth / 2) - (textPainter.width / 2), baseLineY + 5));

    textPainter.text = TextSpan(
      text: label2,
      style: const TextStyle(color: AppTheme.textColor, fontSize: 11, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(bar2Left + (barWidth / 2) - (textPainter.width / 2), baseLineY + 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BarChartPainter) {
      return oldDelegate.value1 != value1 || oldDelegate.value2 != value2 ||
             oldDelegate.value1Color != value1Color || oldDelegate.value2Color != value2Color ||
             oldDelegate.label1 != label1 || oldDelegate.label2 != label2;
    }
    return true;
  }
}


class NumberInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isReadOnly;
  final Color? valueBackgroundColor;
  final Color? valueTextColor;
  final VoidCallback? onInfoTap;

  const NumberInputField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.isReadOnly = false,
    this.valueBackgroundColor,
    this.valueTextColor,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.textColor,
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
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (label.contains('₹'))
                  const Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (label.contains('₹')) const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    readOnly: isReadOnly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isReadOnly ? (valueTextColor ?? AppTheme.textColor) : AppTheme.textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                if (isReadOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: valueBackgroundColor ?? AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: valueTextColor ?? AppTheme.primaryColor,
                      ),
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

// --- Retirement Planning Calculator Page ---
class RetirementPlanningCalculatorPage extends StatefulWidget {
  const RetirementPlanningCalculatorPage({super.key});

  @override
  State<RetirementPlanningCalculatorPage> createState() => _RetirementPlanningCalculatorPageState();
}

class _RetirementPlanningCalculatorPageState extends State<RetirementPlanningCalculatorPage> {
  // All TextEditingControllers are initialized with their default text directly.
  // This is the correct way to handle initial values and avoids the hit-test issue.
  final TextEditingController _currentAgeController = TextEditingController(text: '30');
  final TextEditingController _retirementAgeController = TextEditingController(text: '60');
  final TextEditingController _lifeExpectancyController = TextEditingController(text: '80');
  final TextEditingController _currentMonthlyExpenseController = TextEditingController(text: '20000');
  final TextEditingController _lumpsumInvestNowController = TextEditingController(text: '0');
  final TextEditingController _assumedInflationController = TextEditingController(text: '8');

  double _rateOfReturn = 14.0;

  double _retirementGoalAmount = 0.0;
  double _monthlyExpensesAtRetirement = 0.0;
  double _requiredSIP = 0.0;
  double _requiredLumpsum = 0.0;

  @override
  void initState() {
    super.initState();
    // Listeners correctly trigger calculation on text changes.
    _currentAgeController.addListener(_calculateRetirementPlan);
    _retirementAgeController.addListener(_calculateRetirementPlan);
    _lifeExpectancyController.addListener(_calculateRetirementPlan);
    _currentMonthlyExpenseController.addListener(_calculateRetirementPlan);
    _lumpsumInvestNowController.addListener(_calculateRetirementPlan);
    _assumedInflationController.addListener(_calculateRetirementPlan);
    _calculateRetirementPlan(); // Initial calculation
  }

  @override
  void dispose() {
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _lifeExpectancyController.dispose();
    _currentMonthlyExpenseController.dispose();
    _lumpsumInvestNowController.dispose();
    _assumedInflationController.dispose();
    super.dispose();
  }

  double _parseControllerValue(TextEditingController controller) {
    return double.tryParse(controller.text) ?? 0.0;
  }

  void _calculateRetirementPlan() {
    final currentAge = _parseControllerValue(_currentAgeController);
    final retirementAge = _parseControllerValue(_retirementAgeController);
    final lifeExpectancy = _parseControllerValue(_lifeExpectancyController);
    final currentMonthlyExpense = _parseControllerValue(_currentMonthlyExpenseController);
    final lumpsumInvestNow = _parseControllerValue(_lumpsumInvestNowController);
    final assumedInflation = _parseControllerValue(_assumedInflationController) / 100;
    final rateOfReturn = _rateOfReturn / 100;

    // Basic validation to prevent division by zero or negative time periods
    if (currentAge <= 0 || retirementAge <= 0 || lifeExpectancy <= 0 ||
        currentAge >= retirementAge || retirementAge >= lifeExpectancy ||
        currentMonthlyExpense <= 0 || assumedInflation < 0 || rateOfReturn < 0) {
      setState(() {
        _retirementGoalAmount = 0.0;
        _monthlyExpensesAtRetirement = 0.0;
        _requiredSIP = 0.0;
        _requiredLumpsum = 0.0;
      });
      return;
    }

    final yearsToRetirement = retirementAge - currentAge;
    final yearsInRetirement = lifeExpectancy - retirementAge;

    // Calculate monthly expenses at retirement with inflation
    _monthlyExpensesAtRetirement = currentMonthlyExpense * customPow(1 + assumedInflation, yearsToRetirement);

    // Total retirement corpus needed (future value of expenses in retirement years)
    // This is a simplified calculation, a more accurate one would use PV of an annuity
    // For simplicity, we are taking total expenses for retirement period
    _retirementGoalAmount = (_monthlyExpensesAtRetirement * 12 * yearsInRetirement).clamp(0.0, double.infinity);


    // Calculate how much of the lumpsum needed is covered by current investment
    final FV_lumpsum_invested_now = lumpsumInvestNow * customPow(1 + rateOfReturn, yearsToRetirement);

    // The remaining lumpsum needed if current investment is not enough
    double net_FV_lumpsum_needed = (_retirementGoalAmount - FV_lumpsum_invested_now).clamp(0.0, double.infinity);

    // Calculate the required lumpsum investment now to reach the remaining goal
    if (yearsToRetirement > 0 && rateOfReturn > 0) {
      _requiredLumpsum = net_FV_lumpsum_needed / customPow(1 + rateOfReturn, yearsToRetirement);
    } else {
      _requiredLumpsum = net_FV_lumpsum_needed; // If no growth years, it's just the net amount needed
    }
    _requiredLumpsum = _requiredLumpsum.clamp(0.0, double.infinity);


    // Calculate the required SIP to bridge the gap
    final r_monthly_sip = rateOfReturn / 12;
    final n_months_sip = yearsToRetirement * 12;

    if (n_months_sip > 0 && r_monthly_sip > 0) {
      // Future Value of a series of payments (SIP) formula: FV = P * [((1 + r)^n - 1) / r] * (1 + r)
      // We want to find P (SIP amount) for a target FV (net_FV_lumpsum_needed)
      final term_sip = (customPow(1 + r_monthly_sip, n_months_sip) - 1) / r_monthly_sip;
      if (term_sip > 0) {
        _requiredSIP = net_FV_lumpsum_needed / (term_sip * (1 + r_monthly_sip));
      } else {
        _requiredSIP = 0.0;
      }
    } else if (n_months_sip == 0) {
        _requiredSIP = 0.0; // If yearsToRetirement is 0, no SIP needed for future goal
    } else {
      _requiredSIP = 0.0; // Default for invalid inputs
    }

    // Ensure SIP is non-negative
    _requiredSIP = _requiredSIP.clamp(0.0, double.infinity);


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retirement Calculator'),
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
              // FIX: Ensure the Flex (Row in large screen) has defined constraints
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth, // Takes at least the full width
                ),
                child: IntrinsicHeight( // Ensures children of Flex (columns) match height
                  child: Flex(
                    direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: isLargeScreen ? 3 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                        'It\'s not how much you save, but how early you start and where you invest makes all the difference!',
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

                            Card(
                              color: AppTheme.cardColor,
                              elevation: 6,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NumberInputField(
                                      label: 'What is your current age?',
                                      controller: _currentAgeController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                    ),
                                    NumberInputField(
                                      label: 'At what age do you plan to retire?',
                                      controller: _retirementAgeController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                    ),
                                    NumberInputField(
                                      label: 'What is your life expectancy?',
                                      controller: _lifeExpectancyController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                      onInfoTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('This is an estimated age until you expect to need your retirement fund.'),
                                            backgroundColor: AppTheme.primaryColor,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            margin: const EdgeInsets.all(10),
                                          ),
                                        );
                                      },
                                    ),
                                    NumberInputField(
                                      label: 'What is your current monthly expense?',
                                      controller: _currentMonthlyExpenseController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                    ),
                                    NumberInputField(
                                      label: 'How much Lumpsum amount do you have to invest right now?',
                                      controller: _lumpsumInvestNowController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                    ),
                                    buildSliderInput(
                                      context: context,
                                      label: 'Rate of return',
                                      value: _rateOfReturn,
                                      min: 1,
                                      max: 30,
                                      divisions: 29,
                                      onChanged: (value) {
                                        setState(() {
                                          _rateOfReturn = value;
                                        });
                                        _calculateRetirementPlan();
                                      },
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                    ),
                                    NumberInputField(
                                      label: 'Assumed Inflation',
                                      controller: _assumedInflationController,
                                      onChanged: (_) => _calculateRetirementPlan(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isLargeScreen) const SizedBox(width: 30),

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
                'Retirement Goal Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_retirementGoalAmount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 20),

              if (_parseControllerValue(_currentMonthlyExpenseController) > 0 || _monthlyExpensesAtRetirement > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Monthly Expenses Now', AppTheme.expensesNowColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Monthly Expenses Then', AppTheme.expensesThenColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: CustomPaint(
                        painter: BarChartPainter(
                          value1: _parseControllerValue(_currentMonthlyExpenseController),
                          value2: _monthlyExpensesAtRetirement,
                          label1: 'Monthly Expense Now',
                          label2: 'Monthly Expense Then',
                          value1Color: AppTheme.expensesNowColor,
                          value2Color: AppTheme.expensesThenColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),

              buildResultRow(
                label: 'Monthly Expenses at the time of Retirement',
                value: formatCurrency(_monthlyExpensesAtRetirement),
                valueColor: AppTheme.expensesThenColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required SIP',
                value: formatCurrency(_requiredSIP),
                valueColor: AppTheme.expensesNowColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required Lumpsum',
                value: formatCurrency(_requiredLumpsum),
                valueColor: AppTheme.expensesThenColor,
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