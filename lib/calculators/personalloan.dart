import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:math' as math;

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from image
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color investedColor = Color(0xFFFFCC00); // Yellow for Principal in chart
  static const Color interestColor = Color(0xFFE91E63); // Pink for Total Interest in chart
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color brownColor = Color(0xFF795548); // Brown for Home Loan (unused in this specific file but for consistency)
  static const Color deepOrangeColor = Color(0xFFFF5722); // Deep Orange for Personal Loan (for consistency in a larger app theme)
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

// --- Personal Loan EMI Calculator Page ---
class PersonalLoanEMICalculatorPage extends StatefulWidget {
  const PersonalLoanEMICalculatorPage({super.key});

  @override
  State<PersonalLoanEMICalculatorPage> createState() => _PersonalLoanEMICalculatorPageState();
}

class _PersonalLoanEMICalculatorPageState extends State<PersonalLoanEMICalculatorPage> {
  double _loanAmount = 50000.0;
  double _interestRate = 15.0;
  double _tenureValue = 5.0;
  bool _isYearsSelected = true;

  double _monthlyEMI = 0.0;
  double _totalAmount = 0.0;
  double _totalInterest = 0.0;
  bool _isCalculated = false;

  @override
  void initState() {
    super.initState();
    _calculateEMI();
  }

  void _calculateEMI() {
    final P = _loanAmount;
    final R_annual = _interestRate / 100;
    final R_monthly = R_annual / 12;

    double N_months;
    if (_isYearsSelected) {
      N_months = _tenureValue * 12;
    } else {
      N_months = _tenureValue;
    }

    if (P <= 0 || R_monthly <= 0 || N_months <= 0) {
      setState(() {
        _monthlyEMI = 0.0;
        _totalAmount = 0.0;
        _totalInterest = 0.0;
        _isCalculated = false;
      });
      return;
    }

    final term = customPow(1 + R_monthly, N_months);
    final emi = (P * R_monthly * term) / (term - 1);

    final totalAmount = emi * N_months;
    final totalInterest = totalAmount - P;

    setState(() {
      _monthlyEMI = emi;
      _totalAmount = totalAmount;
      _totalInterest = totalInterest;
      _isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int tenureDivisions = _isYearsSelected ? 19 : 239;
    double tenureMax = _isYearsSelected ? 20.0 : 240.0;
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Loan EMI Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
                                          'A personal loan can help you consolidate debt or fund unexpected expenses.',
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
                                        label: 'Loan Amount',
                                        value: _loanAmount,
                                        min: 10000,
                                        max: 5000000,
                                        divisions: (5000000 - 10000) ~/ 10000 + 1,
                                        onChanged: (value) {
                                          setState(() {
                                            _loanAmount = value;
                                          });
                                          _calculateEMI();
                                        },
                                        unit: '₹',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '₹ 10,000',
                                        maxValueLabel: '₹ 50,00,000',
                                      ),
                                      const SizedBox(height: 16),
                                      buildSliderInput(
                                        context: context,
                                        label: 'Rate of interest (p.a.)',
                                        value: _interestRate,
                                        min: 5,
                                        max: 35,
                                        divisions: 30,
                                        onChanged: (value) {
                                          setState(() {
                                            _interestRate = value;
                                          });
                                          _calculateEMI();
                                        },
                                        unit: '%',
                                        accentColor: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Loan Tenure',
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
                                                _tenureValue = 5.0;
                                              } else {
                                                _tenureValue = 60.0;
                                              }
                                            });
                                            _calculateEMI();
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
                                        value: _tenureValue,
                                        min: 1.0,
                                        max: tenureMax,
                                        divisions: tenureDivisions,
                                        onChanged: (value) {
                                          setState(() {
                                            _tenureValue = value;
                                          });
                                          _calculateEMI();
                                        },
                                        unit: tenureUnit,
                                        accentColor: AppTheme.primaryColor,
                                        hideLabelAbove: true,
                                        minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                        maxValueLabel: _isYearsSelected ? '20 Years' : '240 Months',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '⬇️ Scroll down for Amortisation Table & Chart',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isLargeScreen) const SizedBox(width: 30),
                        Expanded(
                          flex: 2,
                          child: Column(children: _buildResultSection(context)),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'A personal loan can help you consolidate debt or fund unexpected expenses.',
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
                                buildSliderInput(
                                  context: context,
                                  label: 'Loan Amount',
                                  value: _loanAmount,
                                  min: 10000,
                                  max: 5000000,
                                  divisions: (5000000 - 10000) ~/ 10000 + 1,
                                  onChanged: (value) {
                                    setState(() {
                                      _loanAmount = value;
                                    });
                                    _calculateEMI();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.primaryColor,
                                  minValueLabel: '₹ 10,000',
                                  maxValueLabel: '₹ 50,00,000',
                                ),
                                const SizedBox(height: 16),
                                buildSliderInput(
                                  context: context,
                                  label: 'Rate of interest (p.a.)',
                                  value: _interestRate,
                                  min: 5,
                                  max: 35,
                                  divisions: 30,
                                  onChanged: (value) {
                                    setState(() {
                                      _interestRate = value;
                                    });
                                    _calculateEMI();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.primaryColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loan Tenure',
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
                                          _tenureValue = 5.0;
                                        } else {
                                          _tenureValue = 60.0;
                                        }
                                      });
                                      _calculateEMI();
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
                                  value: _tenureValue,
                                  min: 1.0,
                                  max: tenureMax,
                                  divisions: tenureDivisions,
                                  onChanged: (value) {
                                    setState(() {
                                      _tenureValue = value;
                                    });
                                    _calculateEMI();
                                  },
                                  unit: tenureUnit,
                                  accentColor: AppTheme.primaryColor,
                                  hideLabelAbove: true,
                                  minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                  maxValueLabel: _isYearsSelected ? '20 Years' : '240 Months',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '⬇️ Scroll down for Amortisation Table & Chart',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
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
                'Total Amount Payable',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_totalAmount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              if (_isCalculated && (_loanAmount > 0 || _totalInterest > 0))
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Principal Amount', AppTheme.investedColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Total Interest', AppTheme.interestColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CustomPaint(
                        painter: PieChartPainter(
                          investedAmount: _loanAmount,
                          totalInterest: _totalInterest,
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
                label: 'Monthly EMI',
                value: formatCurrency(_monthlyEMI),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Principal Amount',
                value: formatCurrency(_loanAmount),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Total Interest',
                value: formatCurrency(_totalInterest),
                valueColor: AppTheme.interestColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ];
  }
}