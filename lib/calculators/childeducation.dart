import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
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
  // Specific colors for chart (Yellow for Current Cost, Pink for Cost during Admission)
  static const Color currentCostColor = Color(0xFFFFCC00); // Yellow
  static const Color futureCostColor = Color(0xFFE91E63); // Pink
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color limeColor = Color(0xFFCDDC39); // Lime for Child Education (as per icon list)
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the Bar Chart (re-used from other calculators)
class BarChartPainter extends CustomPainter {
  final double value1; // e.g., Current Cost of Education
  final double value2; // e.g., Cost of Education during Admission
  final Color value1Color;
  final Color value2Color;
  final String label1;
  final String label2;

  BarChartPainter({
    required this.value1,
    required this.value2,
    required this.label1,
    required this.label2,
    this.value1Color = AppTheme.currentCostColor, // Yellow
    this.value2Color = AppTheme.futureCostColor, // Pink
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = 40.0; // Width of each bar
    final double spacing = 40.0; // Space between bars
    final double baseLineY = size.height - 20; // Bottom of the chart, adjusted for X-axis labels

    // Find the maximum value to scale the bars
    final double maxValue = (value1 > value2 ? value1 : value2) * 1.2; // Add some padding for max value
    if (maxValue == 0) return; // Avoid division by zero

    // Scale factor to fit bars within the canvas height
    final double scaleFactor = (size.height - 40) / maxValue; // -40 for top margin and X-axis labels

    // Paint for first bar
    final paint1 = Paint()..color = value1Color;
    // Paint for second bar
    final paint2 = Paint()..color = value2Color;

    // Draw first bar
    final double bar1Height = value1 * scaleFactor;
    final double bar1Left = (size.width / 2) - barWidth - (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar1Left, baseLineY - bar1Height, barWidth, bar1Height),
        const Radius.circular(5), // Rounded top corners
      ),
      paint1,
    );

    // Draw second bar
    final double bar2Height = value2 * scaleFactor;
    final double bar2Left = (size.width / 2) + (spacing / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bar2Left, baseLineY - bar2Height, barWidth, bar2Height),
        const Radius.circular(5), // Rounded top corners
      ),
      paint2,
    );

    // Drawing Y-axis labels (optional, simplified)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    final List<double> yAxisValues = [0, maxValue * 0.25, maxValue * 0.5, maxValue * 0.75, maxValue * 0.9]; // Stop before true max for labels
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

// Widget for a customizable number input field (as seen in current age, etc.)
class NumberInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool isReadOnly;
  final Color? valueBackgroundColor;
  final Color? valueTextColor;
  final VoidCallback? onInfoTap; // For the info icon

  const NumberInputField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.initialValue,
    this.isReadOnly = false,
    this.valueBackgroundColor,
    this.valueTextColor,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
          Row(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.textColor,
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
                if (label.contains('₹')) // Add currency symbol only if label implies it
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

// Widget for a customizable slider input (re-used for Rate of Return)
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
                readOnlyValue ? value.toStringAsFixed(1) + unit : (unit == '%' ? '${value.toStringAsFixed(0)} $unit' : '$unit ${value.toStringAsFixed(0)}'),
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
  return '₹ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}';
}

// Helper to calculate power, as `dart:math` is not implicitly available in sandbox
double customPow(double base, double exponent) {
  if (exponent == 0) return 1.0;
  // This is a basic implementation suitable for positive integer exponents.
  // For more robust floating-point exponents, consider importing 'dart:math' and using `math.pow`.
  double result = 1.0;
  for (int i = 0; i < exponent.abs().toInt(); i++) {
    result *= base;
  }
  if (exponent < 0) return 1.0 / result;
  return result;
}

// --- Child Education Calculator Page ---
class ChildEducationCalculatorPage extends StatefulWidget {
  const ChildEducationCalculatorPage({super.key});

  @override
  State<ChildEducationCalculatorPage> createState() => _ChildEducationCalculatorPageState();
}

class _ChildEducationCalculatorPageState extends State<ChildEducationCalculatorPage> {
  // Input Controllers
  final TextEditingController _childCurrentAgeController = TextEditingController(text: '2');
  final TextEditingController _fundsNeededAgeController = TextEditingController(text: '16');
  final TextEditingController _costOfEducationController = TextEditingController(text: '1000000'); // 10 Lakhs

  // Input for slider
  double _expectedRateOfReturn = 14.0; // Annual expected return rate

  // Calculated Values
  double _costOfEducationDuringAdmission = 0.0;
  double _requiredSIP = 0.0;
  double _requiredLumpsum = 0.0;

  // Assumed inflation for education cost (not directly from input, but often used)
  final double _assumedEducationInflation = 8.0; // 8% p.a. inflation for education

  @override
  void initState() {
    super.initState();
    _childCurrentAgeController.addListener(_calculateChildEducation);
    _fundsNeededAgeController.addListener(_calculateChildEducation);
    _costOfEducationController.addListener(_calculateChildEducation);
    _calculateChildEducation(); // Initial calculation
  }

  @override
  void dispose() {
    _childCurrentAgeController.dispose();
    _fundsNeededAgeController.dispose();
    _costOfEducationController.dispose();
    super.dispose();
  }

  double _parseControllerValue(TextEditingController controller) {
    return double.tryParse(controller.text) ?? 0.0;
  }

  void _calculateChildEducation() {
    final childCurrentAge = _parseControllerValue(_childCurrentAgeController);
    final fundsNeededAge = _parseControllerValue(_fundsNeededAgeController);
    final costOfEducationToday = _parseControllerValue(_costOfEducationController);
    final expectedRateOfReturn = _expectedRateOfReturn / 100; // as decimal

    // Basic validation
    if (childCurrentAge <= 0 || fundsNeededAge <= 0 || costOfEducationToday <= 0 ||
        fundsNeededAge <= childCurrentAge || expectedRateOfReturn <= 0) {
      setState(() {
        _costOfEducationDuringAdmission = 0.0;
        _requiredSIP = 0.0;
        _requiredLumpsum = 0.0;
      });
      return;
    }

    final yearsToAdmission = fundsNeededAge - childCurrentAge;
    final inflationRateDecimal = _assumedEducationInflation / 100;

    // 1. Cost of Education during Admission (Future value due to inflation)
    _costOfEducationDuringAdmission = costOfEducationToday * customPow(1 + inflationRateDecimal, yearsToAdmission);

    // 2. Required Lumpsum
    // FV = PV * (1 + r)^n => PV = FV / (1 + r)^n
    _requiredLumpsum = _costOfEducationDuringAdmission / customPow(1 + expectedRateOfReturn, yearsToAdmission);

    // 3. Required SIP
    // FV = P * (((1 + r)^n - 1) / r) * (1 + r)
    // Solve for P (monthly SIP investment)
    final r_monthly_sip = expectedRateOfReturn / 12;
    final n_months_sip = yearsToAdmission * 12;

    if (r_monthly_sip > 0 && n_months_sip > 0) {
      final term_sip = (customPow(1 + r_monthly_sip, n_months_sip) - 1) / r_monthly_sip;
      _requiredSIP = _costOfEducationDuringAdmission / (term_sip * (1 + r_monthly_sip));
    } else {
      _requiredSIP = _costOfEducationDuringAdmission / (n_months_sip == 0 ? 1 : n_months_sip); // Fallback for 0 rate or months
    }

    setState(() {
      // Values are updated directly in the calculation logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Education Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor, // Pink from the image
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.lightbulb_outline, color: Colors.orange[800], size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Your child\'s dreams don\'t come with a price tag—but their education does! Planning today ensures a stress-free tomorrow!',
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
                                NumberInputField(
                                  label: 'What\'s your child\'s current age?',
                                  controller: _childCurrentAgeController,
                                  onChanged: (_) => _calculateChildEducation(),
                                  initialValue: '2', // As per image
                                ),
                                NumberInputField(
                                  label: 'At what age will your child need the funds?',
                                  controller: _fundsNeededAgeController,
                                  onChanged: (_) => _calculateChildEducation(),
                                  initialValue: '16', // As per image
                                ),
                                NumberInputField(
                                  label: 'Cost of Education (as of today)',
                                  controller: _costOfEducationController,
                                  onChanged: (_) => _calculateChildEducation(),
                                  initialValue: '1000000', // As per image
                                  onInfoTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('This is the current cost of the education goal you want to fund.'),
                                        backgroundColor: AppTheme.primaryColor,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        margin: const EdgeInsets.all(10),
                                      ),
                                    );
                                  },
                                ),
                                buildSliderInput(
                                  context: context,
                                  label: 'Expected Rate of Return',
                                  value: _expectedRateOfReturn,
                                  min: 1,
                                  max: 30,
                                  divisions: 29,
                                  onChanged: (value) {
                                    setState(() {
                                      _expectedRateOfReturn = value;
                                    });
                                    _calculateChildEducation();
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
                            child: Column(children: _buildResultSection(context)),
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
                'Cost of Education during Admission',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_costOfEducationDuringAdmission),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor, // Use primary color for main result
                ),
              ),
              const SizedBox(height: 20),

              // Bar Chart and Legend
              if (_costOfEducationDuringAdmission > 0 || _parseControllerValue(_costOfEducationController) > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Current cost of education', AppTheme.currentCostColor), // Yellow
                        const SizedBox(width: 20),
                        buildLegendItem('Cost of education during admission', AppTheme.futureCostColor), // Pink
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200, // Fixed width for the chart
                      height: 150, // Fixed height for the chart
                      child: CustomPaint(
                        painter: BarChartPainter(
                          value1: _parseControllerValue(_costOfEducationController),
                          value2: _costOfEducationDuringAdmission,
                          label1: 'Current cost of education',
                          label2: 'Cost of education during admission',
                          value1Color: AppTheme.currentCostColor, // Yellow
                          value2Color: AppTheme.futureCostColor, // Pink
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
                valueColor: AppTheme.currentCostColor, // Yellow from image
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required Lumpsum',
                value: formatCurrency(_requiredLumpsum),
                valueColor: AppTheme.futureCostColor, // Pink from image
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