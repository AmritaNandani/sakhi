import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakhi/theme/save_theme.dart'; // Ensure this path is correct

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  State<GoalSettingPage> createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> with SingleTickerProviderStateMixin {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  Map<String, dynamic>? _responseData;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeInResultAnimation;
  late Animation<Offset> _slideUpResultAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900), // Slightly longer for flow
    );
    _fadeInResultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideUpResultAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    _amountController.dispose();
    _monthsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // MARK: - Core Logic Methods

  Future<void> _calculateSavings() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard

    final String goal = _goalController.text.trim();
    final double? targetAmount = double.tryParse(_amountController.text.trim());
    final int? duration = int.tryParse(_monthsController.text.trim());

    if (goal.isEmpty || targetAmount == null || duration == null || targetAmount <= 0 || duration <= 0) {
      _showSnackBar('Please enter valid goal, amount, and duration.', error: true);
      setState(() {
        _responseData = null; // Clear previous results on invalid input
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _responseData = null;
      _animationController.reset(); // Reset animation for fresh start
    });

    try {
      final apiUrl = "${dotenv.env['BACKEND_URL']}/save/";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'goal': goal,
          'targetAmount': targetAmount,
          'durationMonths': duration,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseData = jsonDecode(response.body);
        });
        _animationController.forward(); // Start animation for results
        _showSnackBar('Savings plan generated successfully!');
      } else {
        _showSnackBar('Failed to generate savings plan: ${response.statusCode}. ${response.body}', error: true);
      }
    } catch (e) {
      _showSnackBar('Something went wrong: $e', error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // MARK: - UI Build Methods

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE8F5E9), // A very light, calm green background
        body: CustomScrollView( // Using CustomScrollView for more flexible scrolling
          slivers: [
            SliverAppBar( // A subtle, non-traditional app bar
              expandedHeight: 180.0, // Height when fully expanded
              floating: true, // App bar floats over the content when scrolled
              pinned: true, // App bar remains visible at top when scrolled
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: Text(
                  'Your Financial Goal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor.withOpacity(0.9), AppTheme.accentColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Icon(
                        FontAwesomeIcons.bullseye, // Goal-oriented icon
                        color: Colors.white.withOpacity(0.7),
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: AppTheme.primaryColor, // Fallback color
              elevation: 0,
              actions: [
                // Speaker icon on the top right of the AppBar
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                  onPressed: () {
                    // TODO: Implement text-to-speech for the main goal or overall page content
                    String speechText = 'Your financial goal page. '
                                        'Enter your goal, amount, and duration to get a savings plan. '
                                        'Currently, your goal is ${_goalController.text}. '
                                        'Target amount is ${_amountController.text} rupees, '
                                        'in ${_monthsController.text} months.';
                    if (_responseData != null && _responseData!['tip'] != null) {
                      speechText += ' Here is an expert tip: ${_responseData!['tip']}';
                    }
                    _showSnackBar('Simulating reading page aloud!');
                    // Example: FlutterTts().speak(speechText);
                  },
                  tooltip: 'Listen to page content',
                ),
                const SizedBox(width: 10), // Add some spacing
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildInputSection(context),
                    const SizedBox(height: 30),
                    _isLoading
                        ? Column(
                            children: [
                              CircularProgressIndicator(color: AppTheme.primaryColor),
                              const SizedBox(height: 16),
                              Text(
                                'Crunching numbers for your future...',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.lightText),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : _responseData != null
                            ? FadeTransition(
                                opacity: _fadeInResultAnimation,
                                child: SlideTransition(
                                  position: _slideUpResultAnimation,
                                  child: _buildResultSection(context),
                                ),
                              )
                            : _buildInitialPrompt(context),
                    const SizedBox(height: 40),
                    Text(
                      'Achieve your dreams, one step at a time.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightText,
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // Padding at the bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialPrompt(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.stars_rounded, size: 80, color: AppTheme.accentColor.withOpacity(0.5)),
        const SizedBox(height: 20),
        Text(
          'Ready to turn your financial dreams into reality?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Enter your goal details above to get started!',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightText),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: AppTheme.cardColor, // White for the input container
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputField(
            controller: _goalController,
            labelText: 'What is your goal?',
            hintText: 'e.g., New Car',
            icon: Icons.flag_rounded,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _amountController,
            labelText: 'How much do you need? (₹)',
            hintText: 'e.g., 500000',
            icon: FontAwesomeIcons.moneyBillWave,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _monthsController,
            labelText: 'In how many months?',
            hintText: 'e.g., 36',
            icon: Icons.watch_later_rounded,
            keyboardType: TextInputType.number,
            suffixIcon: IconButton(
              icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
              onPressed: () {
                _monthsController.text = '12'; // Simulate voice input
                _showSnackBar('Voice input simulated: 12 months');
              },
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _calculateSavings,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.trending_up_rounded, size: 26),
            label: Text(
              _isLoading ? 'Calculating...' : 'Generate Plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 65), // Even larger button
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8, // More prominent shadow
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.accentColor), // Accent color for input icons
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.lightGrey, width: 1), // Using lightGrey
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.lightGrey, width: 1), // Using lightGrey
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightText),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightText.withOpacity(0.7)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        filled: true,
        fillColor: AppTheme.nearlyWhite, // Use a very light off-white for input background
      ),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
    );
  }

  Widget _buildResultSection(BuildContext context) {
    if (_responseData == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Your Goal: "${_responseData!['goal']}"',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.w800, // Extra bold
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 25),
        _buildSummaryBox(context),
        const SizedBox(height: 25),
        _buildSavingsRateSection(context),
        const SizedBox(height: 25),
        if (_responseData!['recommendedPlan'] != null)
          _buildRecommendedPlanSection(context, _responseData!['recommendedPlan']),
        const SizedBox(height: 25),
        if (_responseData!['tip'] != null) _buildTipSection(_responseData!['tip']),
      ],
    );
  }

  Widget _buildSummaryBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1), // Very light primary accent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.bullseye, color: AppTheme.primaryColor, size: 28),
              const SizedBox(width: 15),
              Text(
                'Target Amount',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _responseData!['targetAmount'], // Corrected: No "₹" prefix here
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w900, // Super bold for numbers
                  letterSpacing: 1.5,
                ),
          ),
          const SizedBox(height: 15),
          Divider(color: AppTheme.primaryColor.withOpacity(0.3), thickness: 1.5),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timelapse_rounded, color: AppTheme.accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                'Duration: ${_responseData!['duration']} months',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsRateSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Savings Needed',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 15),
          _buildSavingsRateItem(
            context,
            'Daily',
            _responseData!['dailySavingNeeded'],
            FontAwesomeIcons.calendarDay,
          ),
          _buildSavingsRateItem(
            context,
            'Weekly',
            _responseData!['weeklySavingNeeded'],
            FontAwesomeIcons.calendarWeek,
          ),
          _buildSavingsRateItem(
            context,
            'Monthly',
            _responseData!['monthlySavingNeeded'],
            FontAwesomeIcons.calendarAlt,
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsRateItem(BuildContext context, String period, String amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.infoColor, size: 24), // Use infoColor for these icons
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              '$period:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textColor),
            ),
          ),
          Text(
            amount, // Corrected: No "₹" prefix here
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.successColor, // Use success color for these
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPlanSection(BuildContext context, Map<String, dynamic> plan) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Action Plan: ${plan['name']}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            plan['description'],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightText, height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          _buildPlanDetailRow(context, 'Category', plan['category'], Icons.category_rounded),
          _buildPlanDetailRow(context, 'Risk Level', plan['riskLevel'], Icons.security_rounded),
          _buildPlanDetailRow(context, 'Typical Returns', plan['typicalReturns'], Icons.trending_up_rounded),
          _buildPlanDetailRow(context, 'Min Investment', plan['minInvestment'], FontAwesomeIcons.handHoldingDollar),
          _buildPlanDetailRow(context, 'Lock-in Period', plan['lockInPeriod'], Icons.lock_clock_rounded),
          _buildPlanDetailRow(context, 'Tax Benefits', plan['taxBenefits'], FontAwesomeIcons.moneyCheckDollar),
          const SizedBox(height: 20),
          Text(
            'Getting Started:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
          ),
          const SizedBox(height: 8),
          Text(
            plan['howToStart'],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetailRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor.withOpacity(0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.textColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightText),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection(String tip) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1), // Light warning color background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warningColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_objects_rounded, color: AppTheme.warningColor, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // Wrap title and speaker icon in a Row
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expert Tip!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.warningColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton( // Speaker Icon Button for the tip
                      icon: const Icon(Icons.volume_up_rounded, color: AppTheme.warningColor, size: 28),
                      onPressed: () {
                        // TODO: Implement text-to-speech for the tip here
                        _showSnackBar('Simulating reading tip aloud!');
                      },
                      tooltip: 'Listen to the tip',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tip,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}