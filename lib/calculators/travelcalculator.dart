import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63);
  static const Color accentColor = Color(0xFFF06292);
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color sectionBgColor = Color(0xFFFFF2D9);
  static const Color currentCostColor = Color(0xFFFFCC00);
  static const Color futureCostColor = Color(0xFFE91E63);
  static const Color greenColor = Color(0xFF4CAF50);
  static const Color blueColor = Color(0xFF2196F3);
  static const Color lightBlueColor = Color(0xFF03A9F4);
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
    this.value1Color = AppTheme.currentCostColor,
    this.value2Color = AppTheme.futureCostColor,
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
      return oldDelegate.value1 != value1 || oldDelegate.value2 != value2 ||
             oldDelegate.value1Color != value1Color || oldDelegate.value2Color != value2Color ||
             oldDelegate.label1 != label1 || oldDelegate.label2 != label2;
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

// --- Travel Calculator Page ---
class TravelCalculatorPage extends StatefulWidget {
  const TravelCalculatorPage({super.key});

  @override
  State<TravelCalculatorPage> createState() => _TravelCalculatorPageState();
}

class _TravelCalculatorPageState extends State<TravelCalculatorPage> {
  final TextEditingController _destinationController = TextEditingController(text: 'Destination');
  double _timePeriodValue = 5.0;
  bool _isYearsSelected = true;
  double _currentMoneyNeeded = 15000.0;
  double _expectedReturnRate = 12.0;

  double _costOfTravelNow = 0.0;
  double _costOfTravelThen = 0.0;
  double _requiredSIP = 0.0;
  double _requiredLumpsum = 0.0;

  final double _inflationRate = 8.0;

  @override
  void initState() {
    super.initState();
    _destinationController.addListener(_calculateTravelCosts);
    _calculateTravelCosts();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _calculateTravelCosts() {
    final P_current = _currentMoneyNeeded;
    final R_inflation = _inflationRate / 100;
    final R_investment = _expectedReturnRate / 100;

    double T_years;
    double N_months;

    if (_isYearsSelected) {
      T_years = _timePeriodValue;
      N_months = _timePeriodValue * 12;
    } else {
      T_years = _timePeriodValue / 12;
      N_months = _timePeriodValue;
    }

    if (P_current <= 0 || T_years <= 0 || N_months <= 0) {
      setState(() {
        _costOfTravelNow = 0.0;
        _costOfTravelThen = 0.0;
        _requiredSIP = 0.0;
        _requiredLumpsum = 0.0;
      });
      return;
    }

    _costOfTravelNow = P_current;
    _costOfTravelThen = P_current * customPow(1 + R_inflation, T_years);

    final FV_sip = _costOfTravelThen;
    final r_monthly_sip = R_investment / 12;

    if (FV_sip > 0 && r_monthly_sip > 0 && N_months > 0) {
      final term_sip = (customPow(1 + r_monthly_sip, N_months) - 1) / r_monthly_sip;
      _requiredSIP = FV_sip / (term_sip * (1 + r_monthly_sip));
    } else {
      _requiredSIP = 0.0;
    }

    final FV_lumpsum = _costOfTravelThen;
    if (FV_lumpsum > 0 && R_investment > 0 && T_years > 0) {
      _requiredLumpsum = FV_lumpsum / customPow(1 + R_investment, T_years);
    } else {
      _requiredLumpsum = 0.0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int tenureDivisions = _isYearsSelected ? 119 : 1439;
    double tenureMax = _isYearsSelected ? 120.0 : 1440.0;
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Calculator'),
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
                              Card(
                                color: AppTheme.cardColor,
                                elevation: 6,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Where are you planning to travel?',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: TextField(
                                          controller: _destinationController,
                                          decoration: const InputDecoration(
                                            hintText: 'Destination',
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'When do you want to travel?',
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
                                                _timePeriodValue = 5.0;
                                              } else {
                                                _timePeriodValue = 60.0;
                                              }
                                            });
                                            _calculateTravelCosts();
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
                                          _calculateTravelCosts();
                                        },
                                        unit: tenureUnit,
                                        accentColor: AppTheme.primaryColor,
                                        hideLabelAbove: true,
                                        minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                        maxValueLabel: _isYearsSelected ? '120 Years' : '1440 Months',
                                      ),
                                      const SizedBox(height: 16),
                                      buildSliderInput(
                                        context: context,
                                        label: 'How much money do you need today?',
                                        value: _currentMoneyNeeded,
                                        min: 100,
                                        max: 10000000,
                                        divisions: (10000000 - 100) ~/ 100 + 1,
                                        onChanged: (value) {
                                          setState(() {
                                            _currentMoneyNeeded = value;
                                          });
                                          _calculateTravelCosts();
                                        },
                                        unit: '₹',
                                        accentColor: AppTheme.primaryColor,
                                        minValueLabel: '₹ 100',
                                        maxValueLabel: '₹ 1,00,00,000',
                                      ),
                                      const SizedBox(height: 16),
                                      buildSliderInput(
                                        context: context,
                                        label: 'Expected rate of return',
                                        value: _expectedReturnRate,
                                        min: 3,
                                        max: 18,
                                        divisions: 15,
                                        onChanged: (value) {
                                          setState(() {
                                            _expectedReturnRate = value;
                                          });
                                          _calculateTravelCosts();
                                        },
                                        unit: '%',
                                        accentColor: AppTheme.primaryColor,
                                      ),
                                      const SizedBox(height: 16),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'ℹ️ Your goal amount is revised assuming 8% p.a. inflation',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
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
                        Card(
                          color: AppTheme.cardColor,
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Where are you planning to travel?',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: _destinationController,
                                    decoration: const InputDecoration(
                                      hintText: 'Destination',
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'When do you want to travel?',
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
                                          _timePeriodValue = 5.0;
                                        } else {
                                          _timePeriodValue = 60.0;
                                        }
                                      });
                                      _calculateTravelCosts();
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
                                    _calculateTravelCosts();
                                  },
                                  unit: tenureUnit,
                                  accentColor: AppTheme.primaryColor,
                                  hideLabelAbove: true,
                                  minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                  maxValueLabel: _isYearsSelected ? '120 Years' : '1440 Months',
                                ),
                                const SizedBox(height: 16),
                                buildSliderInput(
                                  context: context,
                                  label: 'How much money do you need today?',
                                  value: _currentMoneyNeeded,
                                  min: 100,
                                  max: 10000000,
                                  divisions: (10000000 - 100) ~/ 100 + 1,
                                  onChanged: (value) {
                                    setState(() {
                                      _currentMoneyNeeded = value;
                                    });
                                    _calculateTravelCosts();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.primaryColor,
                                  minValueLabel: '₹ 100',
                                  maxValueLabel: '₹ 1,00,00,000',
                                ),
                                const SizedBox(height: 16),
                                buildSliderInput(
                                  context: context,
                                  label: 'Expected rate of return',
                                  value: _expectedReturnRate,
                                  min: 3,
                                  max: 18,
                                  divisions: 15,
                                  onChanged: (value) {
                                    setState(() {
                                      _expectedReturnRate = value;
                                    });
                                    _calculateTravelCosts();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.primaryColor,
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'ℹ️ Your goal amount is revised assuming 8% p.a. inflation',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                    ),
                                  ),
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
                formatCurrency(_costOfTravelThen),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              if (_costOfTravelNow > 0 || _costOfTravelThen > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Cost of travel now', AppTheme.currentCostColor),
                        const SizedBox(width: 20),
                        buildLegendItem('Cost of travel then', AppTheme.futureCostColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 150,
                      child: CustomPaint(
                        painter: BarChartPainter(
                          value1: _costOfTravelNow,
                          value2: _costOfTravelThen,
                          label1: 'Cost of travel now',
                          label2: 'Cost of travel then',
                          value1Color: AppTheme.currentCostColor,
                          value2Color: AppTheme.futureCostColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey[300], thickness: 1),
              const SizedBox(height: 20),
              buildResultRow(
                label: 'Cost of travel now',
                value: formatCurrency(_costOfTravelNow),
                valueColor: AppTheme.currentCostColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Cost of travel then',
                value: formatCurrency(_costOfTravelThen),
                valueColor: AppTheme.futureCostColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required SIP',
                value: formatCurrency(_requiredSIP),
                valueColor: AppTheme.currentCostColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Required Lumpsum',
                value: formatCurrency(_requiredLumpsum),
                valueColor: AppTheme.futureCostColor,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ];
  }
}