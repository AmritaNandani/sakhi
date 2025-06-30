import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- App Theme Definition ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink from general design
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87; // Dark text color
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow for "Did you know?"
  static const Color savingsInvestmentsColor = Color(0xFF4CAF50); // Green
  static const Color needsColor = Color(0xFFFFCC00); // Yellow
  static const Color wantsColor = Color(0xFFE91E63); // Pink
}

// --- Common UI Widgets & Helpers ---

class MultiSlicePieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double strokeWidth;

  MultiSlicePieChartPainter({
    required this.values,
    required this.colors,
    this.strokeWidth = 20.0,
  }) : assert(values.length == colors.length, 'Values and colors lists must have the same length.');

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = values.fold(0.0, (sum, item) => sum + item);
    if (total == 0) return;

    double startAngle = -90 * (3.1415926535 / 180);
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 360 * (3.1415926535 / 180);
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is MultiSlicePieChartPainter) {
      if (oldDelegate.values.length != values.length || oldDelegate.colors.length != colors.length) return true;
      for (int i = 0; i < values.length; i++) {
        if (oldDelegate.values[i] != values[i] || oldDelegate.colors[i] != colors[i]) return true;
      }
    }
    return false;
  }
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

class SalaryInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool isReadOnly;
  final Color? valueBackgroundColor;
  final Color? valueTextColor;

  const SalaryInputField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.initialValue,
    this.isReadOnly = false,
    this.valueBackgroundColor,
    this.valueTextColor,
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
          Text(
            label,
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
            child: Row(
              children: [
                const Text(
                  '₹',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
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

// --- Salary Calculator Page ---
class SalaryCalculatorPage extends StatefulWidget {
  const SalaryCalculatorPage({super.key});

  @override
  State<SalaryCalculatorPage> createState() => _SalaryCalculatorPageState();
}

class _SalaryCalculatorPageState extends State<SalaryCalculatorPage> {
  final TextEditingController _ctcController = TextEditingController();
  final TextEditingController _basicSalaryController = TextEditingController(text: '195368');
  final TextEditingController _statutoryBonusController = TextEditingController(text: '16800');
  final TextEditingController _specialAllowanceController = TextEditingController(text: '57440');
  final TextEditingController _hraController = TextEditingController(text: '97684');
  final TextEditingController _travelAllowanceController = TextEditingController(text: '0');
  final TextEditingController _mealFoodAllowanceController = TextEditingController(text: '0');
  final TextEditingController _anyOtherAllowanceController = TextEditingController(text: '0');
  final TextEditingController _employerPfController = TextEditingController(text: '23444');
  final TextEditingController _employeePfController = TextEditingController(text: '23444');
  final TextEditingController _professionalTaxController = TextEditingController(text: '2400');
  final TextEditingController _employeeNpsController = TextEditingController(text: '0');
  final TextEditingController _insuranceController = TextEditingController(text: '0');

  double _totalAnnualSalaryInHand = 0.0;
  double _totalMonthlyDeductions = 0.0;
  double _totalAnnualDeductions = 0.0;
  double _totalMonthlySalaryInHand = 0.0;

  double _savingsInvestments = 0.0;
  double _needs = 0.0;
  double _wants = 0.0;

  @override
  void initState() {
    super.initState();
    _basicSalaryController.addListener(_calculateSalary);
    _statutoryBonusController.addListener(_calculateSalary);
    _specialAllowanceController.addListener(_calculateSalary);
    _hraController.addListener(_calculateSalary);
    _travelAllowanceController.addListener(_calculateSalary);
    _mealFoodAllowanceController.addListener(_calculateSalary);
    _anyOtherAllowanceController.addListener(_calculateSalary);
    _employerPfController.addListener(_calculateSalary);
    _employeePfController.addListener(_calculateSalary);
    _professionalTaxController.addListener(_calculateSalary);
    _employeeNpsController.addListener(_calculateSalary);
    _insuranceController.addListener(_calculateSalary);

    _calculateSalary();
  }

  @override
  void dispose() {
    _ctcController.dispose();
    _basicSalaryController.dispose();
    _statutoryBonusController.dispose();
    _specialAllowanceController.dispose();
    _hraController.dispose();
    _travelAllowanceController.dispose();
    _mealFoodAllowanceController.dispose();
    _anyOtherAllowanceController.dispose();
    _employerPfController.dispose();
    _employeePfController.dispose();
    _professionalTaxController.dispose();
    _employeeNpsController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  double _parseControllerValue(TextEditingController controller) {
    return double.tryParse(controller.text) ?? 0.0;
  }

  void _calculateSalary() {
    final basicSalary = _parseControllerValue(_basicSalaryController);
    final statutoryBonus = _parseControllerValue(_statutoryBonusController);
    final specialAllowance = _parseControllerValue(_specialAllowanceController);
    final hra = _parseControllerValue(_hraController);
    final travelAllowance = _parseControllerValue(_travelAllowanceController);
    final mealFoodAllowance = _parseControllerValue(_mealFoodAllowanceController);
    final anyOtherAllowance = _parseControllerValue(_anyOtherAllowanceController);

    final employerPf = _parseControllerValue(_employerPfController);
    final employeePf = _parseControllerValue(_employeePfController);
    final professionalTax = _parseControllerValue(_professionalTaxController);
    final employeeNps = _parseControllerValue(_employeeNpsController);
    final insurance = _parseControllerValue(_insuranceController);

    final annualGrossSalary = basicSalary + statutoryBonus + specialAllowance + hra + travelAllowance + mealFoodAllowance + anyOtherAllowance;
    final annualEmployeeDeductions = employeePf + professionalTax + employeeNps + insurance;
    final annualSalaryInHand = annualGrossSalary - annualEmployeeDeductions;
    final calculatedCTC = annualGrossSalary + employerPf;

    final monthlySalaryInHand = annualSalaryInHand / 12;
    final monthlyDeductions = annualEmployeeDeductions / 12;

    _needs = monthlySalaryInHand * 0.50;
    _wants = monthlySalaryInHand * 0.30;
    _savingsInvestments = monthlySalaryInHand * 0.20;

    setState(() {
      _ctcController.text = calculatedCTC.toStringAsFixed(0);
      _totalAnnualSalaryInHand = annualSalaryInHand;
      _totalMonthlyDeductions = monthlyDeductions;
      _totalAnnualDeductions = annualEmployeeDeductions;
      _totalMonthlySalaryInHand = monthlySalaryInHand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculator'),
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
                                          'Do not save what is left after spending, but spend what is left after saving.',
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
                                      SalaryInputField(
                                        label: 'Cost to Company (CTC)',
                                        controller: _ctcController,
                                        isReadOnly: true,
                                        valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                        valueTextColor: AppTheme.primaryColor,
                                      ),
                                      SalaryInputField(
                                        label: 'Basic Salary',
                                        controller: _basicSalaryController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Statutory Bonus',
                                        controller: _statutoryBonusController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Special Allowance',
                                        controller: _specialAllowanceController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'House Rent Allowance',
                                        controller: _hraController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Travel Allowance',
                                        controller: _travelAllowanceController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Meal/Food Allowance',
                                        controller: _mealFoodAllowanceController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Any other Allowance',
                                        controller: _anyOtherAllowanceController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Employer\'s Contribution to PF',
                                        controller: _employerPfController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Employee\'s Contribution to PF',
                                        controller: _employeePfController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SalaryInputField(
                                              label: 'Professional Tax',
                                              controller: _professionalTaxController,
                                              onChanged: (_) => _calculateSalary(),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 24.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text('Professional tax is a state-level tax on income.'),
                                                    backgroundColor: AppTheme.primaryColor,
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    margin: const EdgeInsets.all(10),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.info_outline,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SalaryInputField(
                                        label: 'Employee\'s Contribution to NPS',
                                        controller: _employeeNpsController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                      SalaryInputField(
                                        label: 'Insurance (if any)',
                                        controller: _insuranceController,
                                        onChanged: (_) => _calculateSalary(),
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
                                    'Do not save what is left after spending, but spend what is left after saving.',
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
                                SalaryInputField(
                                  label: 'Cost to Company (CTC)',
                                  controller: _ctcController,
                                  isReadOnly: true,
                                  valueBackgroundColor: AppTheme.accentColor.withOpacity(0.1),
                                  valueTextColor: AppTheme.primaryColor,
                                ),
                                SalaryInputField(
                                  label: 'Basic Salary',
                                  controller: _basicSalaryController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Statutory Bonus',
                                  controller: _statutoryBonusController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Special Allowance',
                                  controller: _specialAllowanceController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'House Rent Allowance',
                                  controller: _hraController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Travel Allowance',
                                  controller: _travelAllowanceController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Meal/Food Allowance',
                                  controller: _mealFoodAllowanceController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Any other Allowance',
                                  controller: _anyOtherAllowanceController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Employer\'s Contribution to PF',
                                  controller: _employerPfController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Employee\'s Contribution to PF',
                                  controller: _employeePfController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SalaryInputField(
                                        label: 'Professional Tax',
                                        controller: _professionalTaxController,
                                        onChanged: (_) => _calculateSalary(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Professional tax is a state-level tax on income.'),
                                              backgroundColor: AppTheme.primaryColor,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              margin: const EdgeInsets.all(10),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SalaryInputField(
                                  label: 'Employee\'s Contribution to NPS',
                                  controller: _employeeNpsController,
                                  onChanged: (_) => _calculateSalary(),
                                ),
                                SalaryInputField(
                                  label: 'Insurance (if any)',
                                  controller: _insuranceController,
                                  onChanged: (_) => _calculateSalary(),
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
                'Total annual salary in hand',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatCurrency(_totalAnnualSalaryInHand),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              if (_totalMonthlySalaryInHand > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLegendItem('Savings & Investments', AppTheme.savingsInvestmentsColor),
                        const SizedBox(width: 10),
                        buildLegendItem('Needs', AppTheme.needsColor),
                        const SizedBox(width: 10),
                        buildLegendItem('Wants', AppTheme.wantsColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CustomPaint(
                        painter: MultiSlicePieChartPainter(
                          values: [_savingsInvestments, _needs, _wants],
                          colors: [AppTheme.savingsInvestmentsColor, AppTheme.needsColor, AppTheme.wantsColor],
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
                label: 'Total Monthly Deductions from Salary',
                value: formatCurrency(_totalMonthlyDeductions),
                valueColor: AppTheme.needsColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Total Annual Deductions from Salary',
                value: formatCurrency(_totalAnnualDeductions),
                valueColor: AppTheme.needsColor,
              ),
              const SizedBox(height: 16),
              buildResultRow(
                label: 'Total Monthly Salary in hand',
                value: formatCurrency(_totalMonthlySalaryInHand),
                valueColor: AppTheme.primaryColor,
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