import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63);
  static const Color accentColor = Color(0xFFF06292);
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color sectionBgColor = Color(0xFFFFF2D9);
  static const Color investedColor = Color(0xFFFFCC00);
  static const Color interestColor = Color(0xFFE91E63);
  static const Color greenColor = Color(0xFF4CAF50);
  static const Color blueColor = Color(0xFF2196F3);
  static const Color orangeColor = Color(0xFFFF9800);
}

// --- Common UI Widgets & Helpers ---

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

    // Guard against invalid values
    final safeInvested = investedAmount.isFinite && investedAmount > 0 ? investedAmount : 0.0;
    final safeInterest = totalInterest.isFinite && totalInterest > 0 ? totalInterest : 0.0;
    final total = safeInvested + safeInterest;

    final investedSweepAngle = total > 0 ? (safeInvested / total) * 360 * (3.1415926535 / 180) : 0.0;
    final interestSweepAngle = total > 0 ? (safeInterest / total) * 360 * (3.1415926535 / 180) : 0.0;

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
  VoidCallback? onInfoTap,
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
                    readOnlyValue
                        ? value.toStringAsFixed(1) + unit
                        : (unit == '%' ? '${value.toStringAsFixed(0)} $unit' : '$unit ${value.toStringAsFixed(0)}'),
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
            value: value.clamp(min, max),
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
  return '₹ ${NumberFormat('#,##0').format(value)}';
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

// --- Simple Interest Calculator Page ---
class SimpleInterestCalculatorPage extends StatefulWidget {
  const SimpleInterestCalculatorPage({super.key});

  @override
  State<SimpleInterestCalculatorPage> createState() => _SimpleInterestCalculatorPageState();
}

class _SimpleInterestCalculatorPageState extends State<SimpleInterestCalculatorPage> {
  static const double minInvested = 100;
  static const double maxInvested = 1000000;
  static const double minRate = 1;
  static const double maxRate = 30;
  static const double minTime = 1;
  static const double maxTime = 50;

  double _amountInvested = 10000.0;
  double _rateOfInterest = 12.0;
  double _timePeriod = 10.0;

  double _totalValue = 0.0;
  double _totalInterest = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _clampInputs();
        _calculateSimpleInterest();
      });
    });
  }

  void _clampInputs() {
    _amountInvested = _amountInvested.clamp(minInvested, maxInvested);
    _rateOfInterest = _rateOfInterest.clamp(minRate, maxRate);
    _timePeriod = _timePeriod.clamp(minTime, maxTime);
  }

  void _calculateSimpleInterest() {
    _clampInputs();
    final P = _amountInvested;
    final R = _rateOfInterest / 100;
    final T = _timePeriod;

    if (P <= 0 || R <= 0 || T <= 0) {
      _totalValue = 0.0;
      _totalInterest = 0.0;
      return;
    }

    final simpleInterest = P * R * T;
    final totalAmount = P + simpleInterest;

    _totalValue = totalAmount;
    _totalInterest = simpleInterest;
  }

  @override
  Widget build(BuildContext context) {
    // Clamp values before every build to avoid layout errors
    _clampInputs();
    _calculateSimpleInterest();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Interest Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen = constraints.maxWidth > 700;

            // Fix: Wrap the Flex in a ConstrainedBox to give it a bounded height
            // when it's horizontal. This prevents the "size: MISSING" error.
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40, // Account for padding
                  // If on a large screen and horizontal, limit the height to the available height
                  // If not a large screen (vertical), let it take its natural height for scrolling
                  maxHeight: isLargeScreen ? constraints.maxHeight - 40 : double.infinity,
                ),
                child: IntrinsicHeight( // Ensures children within the Flex take up their natural height
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
                                        'Choose compound over simple interest to multiply your money faster.',
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
                                      label: 'Amount invested',
                                      value: _amountInvested,
                                      min: minInvested,
                                      max: maxInvested,
                                      divisions: (maxInvested - minInvested) ~/ 100 + 1,
                                      onChanged: (value) {
                                        setState(() {
                                          _amountInvested = value.clamp(minInvested, maxInvested);
                                        });
                                      },
                                      unit: '₹',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '₹ 100',
                                      maxValueLabel: '₹ 10,00,000',
                                    ),
                                    const SizedBox(height: 16),
                                    buildSliderInput(
                                      context: context,
                                      label: 'Rate of interest (p.a.)',
                                      value: _rateOfInterest,
                                      min: minRate,
                                      max: maxRate,
                                      divisions: (maxRate - minRate).toInt(),
                                      onChanged: (value) {
                                        setState(() {
                                          _rateOfInterest = value.clamp(minRate, maxRate);
                                        });
                                      },
                                      unit: '%',
                                      accentColor: AppTheme.primaryColor,
                                      minValueLabel: '1%',
                                      maxValueLabel: '30%',
                                    ),
                                    const SizedBox(height: 16),
                                    buildSliderInput(
                                      context: context,
                                      label: 'Time period',
                                      value: _timePeriod,
                                      min: minTime,
                                      max: maxTime,
                                      divisions: (maxTime - minTime).toInt(),
                                      onChanged: (value) {
                                        setState(() {
                                          _timePeriod = value.clamp(minTime, maxTime);
                                        });
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
    // Guard against invalid values for chart
    final safeInvested = _amountInvested.isFinite && _amountInvested > 0 ? _amountInvested : 0.0;
    final safeInterest = _totalInterest.isFinite && _totalInterest > 0 ? _totalInterest : 0.0;

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
                formatCurrency(_totalValue),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 20),
              if (safeInvested > 0 || safeInterest > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Amount Invested', AppTheme.investedColor),
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
                          investedAmount: safeInvested,
                          totalInterest: safeInterest,
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
                label: 'Amount invested',
                value: formatCurrency(_amountInvested),
                valueColor: AppTheme.investedColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Total interest',
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