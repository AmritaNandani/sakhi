import 'package:flutter/material.dart';
// If you use Font Awesome, uncomment the line below and ensure the package is in pubspec.yaml
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// For mathematical operations like pow, you might need to import dart:math
// import 'dart:math' as math;

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color investedColor = Color(0xFFFFCC00); // Yellow for Principal in chart
  static const Color interestColor = Color(0xFFE91E63); // Pink for Total Interest in chart
  static const Color greenColor = Color(0xFF4CAF50); // General Green
  static const Color blueColor = Color(0xFF2196F3); // General Blue
  static const Color indigoColor = Color(0xFF3F51B5); // Indigo for Car Loan
}

// --- Common UI Widgets & Helpers ---

// Custom Painter for drawing the circular chart (reusable)
class PieChartPainter extends CustomPainter {
  final double investedAmount; // This will be Principal Amount
  final double totalInterest; // This will be Total Interest
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

    // Paint for total interest
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
  bool hideLabelAbove = false, // New parameter to hide label if it's already provided outside
  String? minValueLabel,
  String? maxValueLabel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!hideLabelAbove) // Only show label if not hidden
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
  if (value.isNaN || value.isInfinite) return '₹ 0';
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

// --- Car Loan EMI Calculator Page ---
class CarLoanEMICalculatorPage extends StatefulWidget {
  const CarLoanEMICalculatorPage({super.key});

  @override
  State<CarLoanEMICalculatorPage> createState() => _CarLoanEMICalculatorPageState();
}

class _CarLoanEMICalculatorPageState extends State<CarLoanEMICalculatorPage> {
  double _loanAmount = 500000.0; // Typical starting car loan amount
  double _interestRate = 9.0; // Typical car loan interest rate
  double _tenureValue = 5.0; // Typical car loan tenure (shorter)
  bool _isYearsSelected = true; // true for years, false for months

  double _monthlyEMI = 0.0;
  double _totalAmount = 0.0;
  double _totalInterest = 0.0;
  bool _isCalculated = false;

  @override
  void initState() {
    super.initState();
    _calculateEMI(); // Calculate initial values
  }

  void _calculateEMI() {
    final P = _loanAmount; // Principal Loan Amount
    final R_annual = _interestRate / 100; // Annual interest rate as decimal
    final R_monthly = R_annual / 12; // Monthly interest rate

    double N_months; // Total Number of Months
    if (_isYearsSelected) {
      N_months = _tenureValue * 12; // Convert years to months
    } else {
      N_months = _tenureValue; // Already in months
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

    // EMI Formula: E = [P * R * (1 + R)^N] / [(1 + R)^N – 1]
    // Where:
    // P = Principal Loan Amount
    // R = Monthly Interest Rate (Annual Rate / 12 / 100)
    // N = Total Number of Months
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
    // Determine the max divisions for the loan tenure slider based on selected unit
    int tenureDivisions = _isYearsSelected ? 6 : 83; // 1-7 years (6 divisions), 1-84 months (83 divisions)
    double tenureMax = _isYearsSelected ? 7.0 : 84.0; // Max years or max months (e.g., 7 years for car loan)
    String tenureUnit = _isYearsSelected ? 'Yr' : 'Months';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Loan EMI Calculator'),
        centerTitle: true,
        backgroundColor: AppTheme.indigoColor, // Indigo color for Car Loan
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Apply for Car Loan functionality coming soon!'),
                    backgroundColor: AppTheme.indigoColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.indigoColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: const Text(
                'Apply for Car Loan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen = constraints.maxWidth > 700; // Define a breakpoint for large screens

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
                                    'Car loans can help you drive your dream car without a large upfront payment.',
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
                                  min: 100000,
                                  max: 2000000, // Max car loan up to 20 Lakhs
                                  divisions: (2000000 - 100000) ~/ 10000 + 1, // Divisions for 10k increments
                                  onChanged: (value) {
                                    setState(() {
                                      _loanAmount = value;
                                    });
                                    _calculateEMI();
                                  },
                                  unit: '₹',
                                  accentColor: AppTheme.indigoColor,
                                  minValueLabel: '₹ 1,00,000',
                                  maxValueLabel: '₹ 20,00,000',
                                ),
                                const SizedBox(height: 16),

                                buildSliderInput(
                                  context: context,
                                  label: 'Rate of interest (p.a.)',
                                  value: _interestRate,
                                  min: 5,
                                  max: 20,
                                  divisions: 15, // 5% to 20%
                                  onChanged: (value) {
                                    setState(() {
                                      _interestRate = value;
                                    });
                                    _calculateEMI();
                                  },
                                  unit: '%',
                                  accentColor: AppTheme.indigoColor,
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
                                  padding: const EdgeInsets.all(4), // Padding inside the toggle container
                                  child: ToggleButtons(
                                    isSelected: [_isYearsSelected, !_isYearsSelected],
                                    onPressed: (int index) {
                                      setState(() {
                                        _isYearsSelected = index == 0;
                                        // Reset _tenureValue when switching units to stay within reasonable ranges
                                        if (_isYearsSelected) {
                                          _tenureValue = 5.0; // Default years
                                        } else {
                                          _tenureValue = 60.0; // Default months (5 years)
                                        }
                                      });
                                      _calculateEMI();
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    selectedColor: Colors.white,
                                    fillColor: AppTheme.indigoColor, // Use accent color
                                    color: AppTheme.textColor,
                                    splashColor: AppTheme.indigoColor.withOpacity(0.2),
                                    highlightColor: AppTheme.indigoColor.withOpacity(0.1),
                                    borderColor: Colors.transparent, // No border
                                    selectedBorderColor: Colors.transparent, // No border
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
                                  label: '', // Label handled by "Loan Tenure"
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
                                  accentColor: AppTheme.indigoColor, // Use accent color
                                  hideLabelAbove: true, // Hide the label as it's provided outside
                                  minValueLabel: _isYearsSelected ? '1 Year' : '1 Month',
                                  maxValueLabel: _isYearsSelected ? '7 Years' : '84 Months',
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

                  // Spacer for large screens
                  if (isLargeScreen) const SizedBox(width: 30),

                  // Right Column (Results)
                  Container(
                    width: isLargeScreen ? constraints.maxWidth * 0.4 : null,
                    child: isLargeScreen
                        ? Column(children: _buildResultSection(context))
                        : Padding(
                            padding: const EdgeInsets.only(top: 24.0), // Add top padding if stacked
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
                  color: AppTheme.indigoColor, // Use accent color
                ),
              ),
              const SizedBox(height: 20),

              // Chart and Legend
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
                      width: 150, // Fixed size for the chart
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Apply for Car Loan functionality coming soon!'),
                        backgroundColor: AppTheme.indigoColor, // Use accent color
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.indigoColor, // Use accent color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Apply for Car Loan',
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