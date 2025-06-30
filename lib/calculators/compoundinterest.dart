import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Uncomment if FontAwesome is configured
// import 'package:sakhi/theme/save_theme.dart'; // Uncomment if your theme is configured

// --- App Theme Definition ---
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
  ); // Pink for interest in chart
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the circular chart
class PieChartPainter extends CustomPainter {
  final double investedAmount;
  final double totalInterest;
  final double strokeWidth;

  PieChartPainter({
    required this.investedAmount,
    required this.totalInterest,
    this.strokeWidth = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Calculate total for percentage
    final total = investedAmount + totalInterest;

    // Calculate angles
    final investedSweepAngle = total > 0
        ? (investedAmount / total) * 360 * (3.1415926535 / 180)
        : 0.0;
    final interestSweepAngle = total > 0
        ? (totalInterest / total) * 360 * (3.1415926535 / 180)
        : 0.0;

    // Paint for invested amount
    final investedPaint = Paint()
      ..color = AppTheme.investedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Paint for total interest
    final interestPaint = Paint()
      ..color = AppTheme.interestColor
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
          oldDelegate.totalInterest != totalInterest;
    }
    return true;
  }
}

// Helper to format currency
String formatCurrency(double value) {
  if (value.isNaN || value.isInfinite) return '₹ 0';
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
            minValueLabel ??
                '${min.toStringAsFixed(0)}${unit == 'Years' ? ' Year' : ''}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            maxValueLabel ??
                '${max.toStringAsFixed(0)}${unit == 'Years'
                    ? ' Years'
                    : unit == '₹'
                    ? ',00,000'
                    : ''}',
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

// --- Compound Interest Calculator Page ---
class CompoundInterestCalculatorPage extends StatefulWidget {
  const CompoundInterestCalculatorPage({super.key});

  @override
  State<CompoundInterestCalculatorPage> createState() =>
      _CompoundInterestCalculatorPageState();
}

class _CompoundInterestCalculatorPageState
    extends State<CompoundInterestCalculatorPage> {
  double _principal = 100.0;
  double _annualRate = 12.0;
  double _timeYears = 5.0;
  String _compoundingFrequency = '1'; // Default: Annually (1 time/year)

  double _futureValue = 0.0;
  double _totalInterest = 0.0;
  bool _isCalculated = false;

  final List<Map<String, dynamic>> _compoundingOptions = const [
    {'value': '1', 'label': 'Yearly'},
    {'value': '2', 'label': 'Half-Yearly'},
    {'value': '4', 'label': 'Quarterly'},
    {'value': '12', 'label': 'Monthly'},
    {'value': '365', 'label': 'Daily'},
  ];

  @override
  void initState() {
    super.initState();
    _calculateCompoundInterest(); // Calculate initial values
  }

  void _calculateCompoundInterest() {
    final p = _principal;
    final r = _annualRate / 100; // Annual rate as decimal
    final t = _timeYears; // Time in years
    final n = double.parse(
      _compoundingFrequency,
    ); // Number of times interest is compounded per year

    // Compound Interest Formula: A = P(1 + r/n)^(nt)
    final base = 1 + r / n;
    final power = n * t;
    final futureValue = p * customPow(base, power);

    final totalInterest = futureValue - p;

    setState(() {
      _futureValue = futureValue;
      _totalInterest = totalInterest;
      _isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compound Interest Calculator'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
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
                          'Did you know, Compound Interest is the 8th miracle of the world?',
                          style: Theme.of(context).textTheme.titleMedium
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
                        label: 'Amount invested',
                        value: _principal,
                        min: 100,
                        max: 100000,
                        divisions: 999,
                        onChanged: (value) {
                          setState(() {
                            _principal = value;
                          });
                          _calculateCompoundInterest();
                        },
                        unit: '₹',
                        accentColor: AppTheme.primaryColor,
                        minValueLabel: '₹ 100',
                        maxValueLabel: '₹ 1,00,000',
                      ),
                      buildSliderInput(
                        context: context,
                        label: 'Rate of interest (p.a.)',
                        value: _annualRate,
                        min: 1,
                        max: 30,
                        divisions: 29,
                        onChanged: (value) {
                          setState(() {
                            _annualRate = value;
                          });
                          _calculateCompoundInterest();
                        },
                        unit: '%',
                        accentColor: AppTheme.primaryColor,
                      ),
                      buildSliderInput(
                        context: context,
                        label: 'Time period',
                        value: _timeYears,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (value) {
                          setState(() {
                            _timeYears = value;
                          });
                          _calculateCompoundInterest();
                        },
                        unit: 'Years',
                        accentColor: AppTheme.primaryColor,
                        minValueLabel: '1 Year',
                        maxValueLabel: '50 Years',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Compounding frequency',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _compoundingFrequency,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: _compoundingOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _compoundingFrequency = newValue;
                            });
                            _calculateCompoundInterest();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Result Section
              Card(
                color: AppTheme.cardColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Total value',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCurrency(_futureValue),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Chart and Legend
                      if (_isCalculated &&
                          (_principal > 0 || _totalInterest > 0))
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildLegendItem(
                                  'Amount Invested',
                                  AppTheme.investedColor,
                                ),
                                const SizedBox(width: 20),
                                buildLegendItem(
                                  'Total Interest',
                                  AppTheme.interestColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: CustomPaint(
                                painter: PieChartPainter(
                                  investedAmount: _principal,
                                  totalInterest: _totalInterest,
                                  strokeWidth: 25.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      Divider(color: Colors.grey[300], thickness: 1),
                      const SizedBox(height: 20),

                      buildResultRow(
                        label: 'Amount invested',
                        value: formatCurrency(_principal),
                        valueColor: AppTheme.investedColor,
                      ),
                      const SizedBox(height: 16),
                      buildResultRow(
                        label: 'Total interest',
                        value: formatCurrency(_totalInterest),
                        valueColor: AppTheme.interestColor,
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
