import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:math' as math;

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color investedColor = Color(0xFFFFCC00); // Yellow for "Current Cost" bar
  static const Color interestColor = Color(0xFFE91E63); // Pink for "Total Inflation" bar
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color redAccentColor = Color(0xFFFF5252); // Red Accent for Inflation
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
    this.value1Color = AppTheme.investedColor,
    this.value2Color = AppTheme.primaryColor,
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

// --- Inflation Calculator Page ---
class InflationCalculatorPage extends StatefulWidget {
  const InflationCalculatorPage({super.key});

  @override
  State<InflationCalculatorPage> createState() => _InflationCalculatorPageState();
}

class _InflationCalculatorPageState extends State<InflationCalculatorPage> {
  double _currentCost = 15000.0;
  double _inflationRate = 12.0;
  double _timePeriod = 10.0;

  double _futureCost = 0.0;
  double _costIncrease = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateInflation();
  }

  void _calculateInflation() {
    final P = _currentCost;
    final r = _inflationRate / 100;
    final t = _timePeriod;

    if (P <= 0 || r <= 0 || t <= 0) {
      setState(() {
        _futureCost = 0.0;
        _costIncrease = 0.0;
      });
      return;
    }

    final futureCost = P * customPow(1 + r, t);
    final costIncrease = futureCost - P;

    setState(() {
      _futureCost = futureCost;
      _costIncrease = costIncrease;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inflation Calculator'),
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
              child: isLargeScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
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
                                          'Inflation shrinks savings—invest to protect them.',
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
                                        label: 'Current cost',
                                        value: _currentCost,
                                        min: 100,
                                        max: 10000000,
                                        divisions: (10000000 - 100) ~/ 100 + 1,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentCost = value;
                                          });
                                          _calculateInflation();
                                        },
                                        unit: '₹',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '₹ 100',
                                        maxValueLabel: '₹ 1,00,00,000',
                                      ),
                                      const SizedBox(height: 16),

                                      buildSliderInput(
                                        context: context,
                                        label: 'Rate of interest (p.a.)',
                                        value: _inflationRate,
                                        min: 1,
                                        max: 30,
                                        divisions: 29,
                                        onChanged: (value) {
                                          setState(() {
                                            _inflationRate = value;
                                          });
                                          _calculateInflation();
                                        },
                                        unit: '%',
                                        accentColor: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(height: 16),

                                      buildSliderInput(
                                        context: context,
                                        label: 'Time period',
                                        value: _timePeriod,
                                        min: 1,
                                        max: 50,
                                        divisions: 49,
                                        onChanged: (value) {
                                          setState(() {
                                            _timePeriod = value;
                                          });
                                          _calculateInflation();
                                        },
                                        unit: 'Yr',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '1 Year',
                                        maxValueLabel: '50 Years',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          flex: 2,
                          child: Column(children: _buildResultSection(context)),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'Inflation shrinks savings—invest to protect them.',
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
                                  label: 'Current cost',
                                  value: _currentCost,
                                  min: 100,
                                  max: 10000000,
                                  divisions: (10000000 - 100) ~/ 100 + 1,
                                  onChanged: (value) {
                                    setState(() {
                                      _currentCost = value;
                                    });
                                    _calculateInflation();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.primaryColor,
                                  minValueLabel: '₹ 100',
                                  maxValueLabel: '₹ 1,00,00,000',
                                ),
                                const SizedBox(height: 16),

                                buildSliderInput(
                                  context: context,
                                  label: 'Rate of interest (p.a.)',
                                  value: _inflationRate,
                                  min: 1,
                                  max: 30,
                                  divisions: 29,
                                  onChanged: (value) {
                                    setState(() {
                                      _inflationRate = value;
                                    });
                                    _calculateInflation();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.primaryColor,
                                ),
                                const SizedBox(height: 16),

                                buildSliderInput(
                                  context: context,
                                  label: 'Time period',
                                  value: _timePeriod,
                                  min: 1,
                                  max: 50,
                                  divisions: 49,
                                  onChanged: (value) {
                                    setState(() {
                                      _timePeriod = value;
                                    });
                                    _calculateInflation();
                                  },
                                  unit: 'Yr',
                                  accentColor: AppTheme.primaryColor,
                                  minValueLabel: '1 Year',
                                  maxValueLabel: '50 Years',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ..._buildResultSection(context),
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
                'Future Cost',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_futureCost),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              if (_currentCost > 0 || _costIncrease > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Current cost', AppTheme.investedColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Total inflation', AppTheme.interestColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 150,
                      child: CustomPaint(
                        painter: BarChartPainter(
                          value1: _currentCost,
                          value2: _costIncrease,
                          label1: 'Current Cost',
                          label2: 'Total Inflation',
                          value1Color: AppTheme.investedColor,
                          value2Color: AppTheme.interestColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),

              buildResultRow(
                label: 'Current cost',
                value: formatCurrency(_currentCost),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Cost increase',
                value: formatCurrency(_costIncrease),
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