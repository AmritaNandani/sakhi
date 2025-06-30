import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'dart:math' as math; // Import dart:math for the pow function

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow
  static const Color goalAmountColor = Color(0xFFFFCC00); // Yellow
  static const Color revisedAmountColor = Color(0xFFE91E63); // Pink
  static const Color greenColor = Color(0xFF4CAF50);
  static const Color blueColor = Color(0xFF2196F3);
  static const Color greyColor = Color(0xFF9E9E9E);
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the Bar Chart
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
    this.value1Color = AppTheme.goalAmountColor,
    this.value2Color = AppTheme.revisedAmountColor,
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

    final List<double> yAxisValues = [0, maxValue * 0.25, maxValue * 0.5, maxValue * 0.75, maxValue * 0.9];
    for (var val in yAxisValues) {
      final yPos = baseLineY - (val * scaleFactor);
      textPainter.text = TextSpan(
        text: formatCurrency(val),
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width - 5, yPos - textPainter.height / 2));
    }

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
      return oldDelegate.value1 != value1 ||
          oldDelegate.value2 != value2 ||
          oldDelegate.value1Color != value1Color ||
          oldDelegate.value2Color != value2Color ||
          oldDelegate.label1 != label1 ||
          oldDelegate.label2 != label2;
    }
    return true;
  }
}

// Widget for a customizable number input field
class NumberInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool isReadOnly;
  final Color? valueBackgroundColor;
  final Color? valueTextColor;
  final VoidCallback? onInfoTap;

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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                // This section might be redundant if TextField.readOnly is used
                // but kept as is for now to match previous code's intent.
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
  if (value.isNaN || value.isInfinite || value < 0) return '₹ 0';
  return '₹ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d\d\d)+(?!\d))'), (Match m) => '${m[1]},')}';
}

// --- Goal Calculator Page ---
class GoalCalculatorPage extends StatefulWidget {
  const GoalCalculatorPage({super.key});

  @override
  State<GoalCalculatorPage> createState() => _GoalCalculatorPageState();
}

class _GoalCalculatorPageState extends State<GoalCalculatorPage> {
  final TextEditingController _goalAmountController = TextEditingController(text: '200000');

  double _expectedRateOfReturn = 14.0;
  double _timePeriodValue = 10.0;
  bool _isYearsSelected = true;

  double _revisedGoalAmount = 0.0;
  double _requiredSIP = 0.0;
  double _requiredLumpsum = 0.0;

  final double _assumedInflationRate = 8.0;

  @override
  void initState() {
    super.initState();
    _goalAmountController.addListener(_calculateGoal);
    _calculateGoal();
  }

  @override
  void dispose() {
    _goalAmountController.dispose();
    super.dispose();
  }

  double _parseControllerValue(TextEditingController controller) {
    return double.tryParse(controller.text) ?? 0.0;
  }

  void _calculateGoal() {
    final goalAmountToday = _parseControllerValue(_goalAmountController);
    final expectedRateOfReturn = _expectedRateOfReturn / 100;
    final inflationRate = _assumedInflationRate / 100;

    double yearsForCalculation;
    double monthsForCalculation;

    if (_isYearsSelected) {
      yearsForCalculation = _timePeriodValue;
      monthsForCalculation = _timePeriodValue * 12;
    } else {
      yearsForCalculation = _timePeriodValue / 12;
      monthsForCalculation = _timePeriodValue;
    }

    if (goalAmountToday <= 0 || (yearsForCalculation <= 0 && monthsForCalculation <= 0) || expectedRateOfReturn <= 0) {
      setState(() {
        _revisedGoalAmount = 0.0;
        _requiredSIP = 0.0;
        _requiredLumpsum = 0.0;
      });
      return;
    }

    _revisedGoalAmount = goalAmountToday * math.pow(1 + inflationRate, yearsForCalculation);

    _requiredLumpsum = _revisedGoalAmount / math.pow(1 + expectedRateOfReturn, yearsForCalculation);

    final r_monthly_sip = expectedRateOfReturn / 12;

    if (r_monthly_sip > 0 && monthsForCalculation > 0) {
      final term_sip = (math.pow(1 + r_monthly_sip, monthsForCalculation) - 1) / r_monthly_sip;
      _requiredSIP = _revisedGoalAmount / (term_sip * (1 + r_monthly_sip));
    } else {
      // Handle the case where r_monthly_sip is 0 (rate of return is 0) or monthsForCalculation is 0
      _requiredSIP = _revisedGoalAmount / (monthsForCalculation == 0 ? 1 : monthsForCalculation);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int tenureDivisions = _isYearsSelected ? 49 : 599;
    double tenureMax = _isYearsSelected ? 50.0 : 600.0;
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goal Calculator'),
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
              child: Flex(
                direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Inputs)
                  // Conditionally wrap with Flexible based on screen size
                  isLargeScreen
                      ? Flexible(
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
                                          'Invest in your dreams, the time is NOW!',
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
                                        label: 'Your goal amount',
                                        controller: _goalAmountController,
                                        onChanged: (_) => _calculateGoal(),
                                        initialValue: '200000',
                                      ),
                                      buildSliderInput(
                                        context: context,
                                        label: 'Expected rate of return',
                                        value: _expectedRateOfReturn,
                                        min: 1,
                                        max: 30,
                                        divisions: 29,
                                        onChanged: (value) {
                                          setState(() {
                                            _expectedRateOfReturn = value;
                                          });
                                          _calculateGoal();
                                        },
                                        unit: '%',
                                        accentColor: AppTheme.primaryColor,
                                      ),
                                      Text(
                                        'Time period of investment',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: ToggleButtons(
                                          isSelected: [_isYearsSelected, !_isYearsSelected],
                                          onPressed: (int index) {
                                            setState(() {
                                              _isYearsSelected = index == 0;
                                              if (_isYearsSelected) {
                                                _timePeriodValue = 10.0;
                                              } else {
                                                _timePeriodValue = 120.0;
                                              }
                                            });
                                            _calculateGoal();
                                          },
                                          borderRadius: BorderRadius.circular(8),
                                          selectedColor: Colors.white,
                                          fillColor: AppTheme.primaryColor,
                                          color: AppTheme.textColor,
                                          splashColor: AppTheme.primaryColor.withOpacity(0.2),
                                          highlightColor: AppTheme.primaryColor.withOpacity(0.1),
                                          borderColor: Colors.transparent,
                                          selectedBorderColor: Colors.transparent,
                                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                          children: const <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              child: Text('Years'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                              child: Text('Months'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      buildSliderInput(
                                        context: context,
                                        label: '',
                                        value: _timePeriodValue,
                                        min: 1.0,
                                        max: tenureMax,
                                        divisions: tenureDivisions,
                                        onChanged: (value) {
                                          setState(() {
                                            _timePeriodValue = value;
                                          });
                                          _calculateGoal();
                                        },
                                        unit: tenureUnit,
                                        accentColor: AppTheme.primaryColor,
                                        hideLabelAbove: true,
                                        minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                        maxValueLabel: _isYearsSelected ? '50 Years' : '600 Months',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column( // Directly use Column on small screens (no Flexible)
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
                                        'Invest in your dreams, the time is NOW!',
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
                                      label: 'Your goal amount',
                                      controller: _goalAmountController,
                                      onChanged: (_) => _calculateGoal(),
                                      initialValue: '200000',
                                    ),
                                    buildSliderInput(
                                      context: context,
                                      label: 'Expected rate of return',
                                      value: _expectedRateOfReturn,
                                      min: 1,
                                      max: 30,
                                      divisions: 29,
                                      onChanged: (value) {
                                        setState(() {
                                          _expectedRateOfReturn = value;
                                        });
                                        _calculateGoal();
                                      },
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                    ),
                                    Text(
                                      'Time period of investment',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: ToggleButtons(
                                        isSelected: [_isYearsSelected, !_isYearsSelected],
                                        onPressed: (int index) {
                                          setState(() {
                                            _isYearsSelected = index == 0;
                                            if (_isYearsSelected) {
                                              _timePeriodValue = 10.0;
                                            } else {
                                              _timePeriodValue = 120.0;
                                            }
                                          });
                                          _calculateGoal();
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        selectedColor: Colors.white,
                                        fillColor: AppTheme.primaryColor,
                                        color: AppTheme.textColor,
                                        splashColor: AppTheme.primaryColor.withOpacity(0.2),
                                        highlightColor: AppTheme.primaryColor.withOpacity(0.1),
                                        borderColor: Colors.transparent,
                                        selectedBorderColor: Colors.transparent,
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        children: const <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: Text('Years'),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            child: Text('Months'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    buildSliderInput(
                                      context: context,
                                      label: '',
                                      value: _timePeriodValue,
                                      min: 1.0,
                                      max: tenureMax,
                                      divisions: tenureDivisions,
                                      onChanged: (value) {
                                        setState(() {
                                          _timePeriodValue = value;
                                        });
                                        _calculateGoal();
                                      },
                                      unit: tenureUnit,
                                      accentColor: AppTheme.primaryColor,
                                      hideLabelAbove: true,
                                      minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                      maxValueLabel: _isYearsSelected ? '50 Years' : '600 Months',
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
                  // Conditionally wrap with Flexible based on screen size
                  isLargeScreen
                      ? Flexible(
                          flex: 2,
                          child: Column(children: _buildResultSection(context)),
                        )
                      : Padding( // Directly use Padding on small screens (no Flexible)
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
                'Revised Goal Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_revisedGoalAmount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              if (_revisedGoalAmount > 0 || _parseControllerValue(_goalAmountController) > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Goal Amount', AppTheme.goalAmountColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Revised Amount', AppTheme.revisedAmountColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 150,
                      child: CustomPaint(
                        painter: BarChartPainter(
                          value1: _parseControllerValue(_goalAmountController),
                          value2: _revisedGoalAmount,
                          label1: 'Goal Amount',
                          label2: 'Revised Amount',
                          value1Color: AppTheme.goalAmountColor,
                          value2Color: AppTheme.revisedAmountColor,
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
                valueColor: AppTheme.goalAmountColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required Lumpsum',
                value: formatCurrency(_requiredLumpsum),
                valueColor: AppTheme.revisedAmountColor,
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

// Main function to run the app (for demonstration purposes, if not already in main.dart)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Calculator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const GoalCalculatorPage(),
    );
  }
}