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
  static const Color investedColor = Color(0xFFFFCC00); // Yellow for "Invested Amount" in chart
  static const Color interestColor = Color(0xFFE91E63); // Pink for "Estimated Returns" in chart
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the circular chart (reusable)
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

// --- Lumpsum Calculator Page ---
class LumpsumCalculatorPage extends StatefulWidget {
  const LumpsumCalculatorPage({super.key});

  @override
  State<LumpsumCalculatorPage> createState() => _LumpsumCalculatorPageState();
}

class _LumpsumCalculatorPageState extends State<LumpsumCalculatorPage> {
  double _totalInvestment = 15000.0;
  double _timePeriodValue = 10.0;
  bool _isYearsSelected = true;
  double _expectedReturnRate = 12.0;

  double _maturityAmount = 0.0;
  double _estimatedReturns = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateLumpsum();
  }

  void _calculateLumpsum() {
    final P = _totalInvestment;
    final r = _expectedReturnRate / 100;

    double t;
    if (_isYearsSelected) {
      t = _timePeriodValue;
    } else {
      t = _timePeriodValue / 12;
    }

    if (P <= 0 || r <= 0 || t <= 0) {
      setState(() {
        _maturityAmount = 0.0;
        _estimatedReturns = 0.0;
      });
      return;
    }

    final futureValue = P * customPow(1 + r, t);
    final estimatedReturns = futureValue - P;

    setState(() {
      _maturityAmount = futureValue;
      _estimatedReturns = estimatedReturns;
    });
  }

  @override
  Widget build(BuildContext context) {
    int tenureDivisions = _isYearsSelected ? 49 : 599;
    double tenureMax = _isYearsSelected ? 50.0 : 600.0;
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumpsum Calculator'),
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
                                          'Don\'t wait for the right time to start investing. Start early to enjoy the power of compounding!',
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
                                        label: 'What is your total investment amount?',
                                        value: _totalInvestment,
                                        min: 100,
                                        max: 10000000,
                                        divisions: (10000000 - 100) ~/ 100 + 1,
                                        onChanged: (value) {
                                          setState(() {
                                            _totalInvestment = value;
                                          });
                                          _calculateLumpsum();
                                        },
                                        unit: '₹',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '₹ 100',
                                        maxValueLabel: '₹ 1,00,00,000',
                                      ),
                                      const SizedBox(height: 16),

                                      Text(
                                        'What is the time period in years?',
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
                                            _calculateLumpsum();
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
                                          _calculateLumpsum();
                                        },
                                        unit: tenureUnit,
                                        accentColor: AppTheme.primaryColor,
                                        hideLabelAbove: true,
                                        minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                        maxValueLabel: _isYearsSelected ? '50 Years' : '600 Months',
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
                                          _calculateLumpsum();
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
                                    'Don\'t wait for the right time to start investing. Start early to enjoy the power of compounding!',
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
                                  label: 'What is your total investment amount?',
                                  value: _totalInvestment,
                                  min: 100,
                                  max: 10000000,
                                  divisions: (10000000 - 100) ~/ 100 + 1,
                                  onChanged: (value) {
                                    setState(() {
                                      _totalInvestment = value;
                                    });
                                    _calculateLumpsum();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.primaryColor,
                                  minValueLabel: '₹ 100',
                                  maxValueLabel: '₹ 1,00,00,000',
                                ),
                                const SizedBox(height: 16),

                                Text(
                                  'What is the time period in years?',
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
                                      _calculateLumpsum();
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
                                    _calculateLumpsum();
                                  },
                                  unit: tenureUnit,
                                  accentColor: AppTheme.primaryColor,
                                  hideLabelAbove: true,
                                  minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                  maxValueLabel: _isYearsSelected ? '50 Years' : '600 Months',
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
                                    _calculateLumpsum();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.primaryColor,
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
                'Total value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
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

              if (_totalInvestment > 0 || _estimatedReturns > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Invested Amount', AppTheme.investedColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Estimated Returns', AppTheme.interestColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CustomPaint(
                        painter: PieChartPainter(
                          investedAmount: _totalInvestment,
                          totalInterest: _estimatedReturns,
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