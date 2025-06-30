import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart'; // Assuming AppTheme is in save_theme.dart
import 'package:sakhi/services/api_service.dart';

class FinancialTermsPage extends StatefulWidget {
  const FinancialTermsPage({super.key});

  @override
  State<FinancialTermsPage> createState() => _FinancialTermsPageState();
}

class _FinancialTermsPageState extends State<FinancialTermsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _termController = TextEditingController();
  // State variables to hold API response data
  String _term = '';
  String _definition = '';
  String _simpleExplanation = '';
  String _example = '';
  bool _isLoading = false;
  bool _hasExplanation = false; // Controls visibility of explanation section

  // Animation controllers for smooth UI transitions
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Slightly longer for smoother feel
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _termController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // MARK: - Core Logic Methods

  /// Fetches the explanation for the entered financial term from the API.
  void _getExplanation() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final String term = _termController.text.trim();

    if (term.isEmpty) {
      _showSnackBar('Please type a financial term to explain.', error: true);
      _clearExplanation(); // Clear any previous explanation
      setState(() => _hasExplanation = false); // Ensure explanation section is hidden
      return;
    }

    setState(() {
      _isLoading = true;
      _hasExplanation = false; // Hide previous explanation while loading new one
      _clearExplanation(); // Clear previous data
      _animationController.reset(); // Reset animation for fresh start
    });

    try {
      final response = await ApiService().post("/learn/", {"term": term.toLowerCase()});

      if (response != null && response['definition'] != null) {
        setState(() {
          _term = response['term'] ?? term; // Use returned term or input term
          _definition = response['definition'];
          _simpleExplanation = response['simpleExplanation'] ?? '';
          _example = response['example'] ?? '';
          _isLoading = false;
          _hasExplanation = true; // Show explanation section
        });
        _animationController.forward(); // Start fade-in/slide-up animation
        _showSnackBar('Explanation ready!');
      } else {
        // Handle cases where API returns null or no definition
        setState(() {
          _simpleExplanation = 'Sorry, I could not find information for this term. Please try another word.';
          _isLoading = false;
          _hasExplanation = true; // Still show a message, even if it's an error
        });
        _animationController.forward(); // Animate the error message in
        _showSnackBar('No explanation found.');
      }
    } catch (e) {
      // Handle API call errors
      setState(() {
        _clearExplanation();
        _isLoading = false;
        _hasExplanation = true; // Show an error message
        _simpleExplanation = 'Could not connect to service. Please check your internet connection.'; // Generic error message
      });
      _animationController.forward(); // Animate the error message in
      _showSnackBar('Something went wrong: $e', error: true);
    }
  }

  /// Clears all explanation related state variables.
  void _clearExplanation() {
    setState(() {
      _term = '';
      _definition = '';
      _simpleExplanation = '';
      _example = '';
    });
  }

  /// Displays a SnackBar message to the user.
  void _showSnackBar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? AppTheme.errorColor : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating, // Floats above content
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10), // Margin from edges
      ),
    );
  }

  // MARK: - UI Build Methods

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor, // Flat background color from theme
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: Column(
          children: [
            _buildAppBar(context), // Custom AppBar/Header
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0), // Padding for the main content area
                children: [
                  const SizedBox(height: 10),
                  _buildSearchBar(context), // Search input field
                  const SizedBox(height: 30),
                  // Conditional rendering for loading state or explanation content
                  _isLoading
                      ? Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(color: AppTheme.primaryColor),
                              const SizedBox(height: 16),
                              Text(
                                'Unlocking financial wisdom...',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.lightText),
                              ),
                            ],
                          ),
                        )
                      : _hasExplanation // Check if there's an explanation to show
                          ? FadeTransition(
                              opacity: _fadeInAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: _buildExplanationContent(context), // Render explanation
                              ),
                            )
                          : Container(), // Nothing to show if not loading and no explanation
                  const SizedBox(height: 40),
                  Text(
                    'Your guide to understanding the world of finance.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightText,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the custom header/app bar section of the page.
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)), // Rounded bottom edge
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Financial Glossary',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Icon(
            FontAwesomeIcons.coins, // Thematic icon
            color: Colors.white70,
            size: 30,
          ),
        ],
      ),
    );
  }

  /// Builds the search bar input field.
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor, // White background for search bar
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.sectionBorderColor, width: 1.5), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _termController,
        decoration: InputDecoration(
          hintText: 'Type a financial term...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightText.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
          suffixIcon: _isLoading // Show loading indicator in suffix if loading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: AppTheme.primaryColor, strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.mic_rounded, color: AppTheme.primaryColor),
                  onPressed: () {
                    // Simulate voice input and trigger search
                    _termController.text = 'inflation';
                    _showSnackBar('Voice input simulated: "inflation"');
                    _getExplanation(); // Automatically search after simulated input
                  },
                ),
          border: InputBorder.none, // No default border from InputDecoration
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
        onSubmitted: (_) => _getExplanation(), // Trigger search on keyboard submit
      ),
    );
  }

  /// Builds the main content area for the explanation (definition, simple explanation, example).
  Widget _buildExplanationContent(BuildContext context) {
    // If no data found from API (and not a generic error handled by _simpleExplanation)
    if (_definition.isEmpty && _simpleExplanation.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            Icon(Icons.sentiment_dissatisfied_rounded, size: 80, color: AppTheme.lightText),
            const SizedBox(height: 20),
            Text(
              _simpleExplanation, // This will contain the "Sorry, no info" or "connection error" message
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.lightText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _term.toUpperCase(), // Display term in uppercase
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textColor, // Using textColor for main heading
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Divider(color: AppTheme.primaryColor.withOpacity(0.4), thickness: 2, endIndent: MediaQuery.of(context).size.width * 0.4), // Thematic divider
        const SizedBox(height: 20),
        _buildSection(
          context,
          'Definition',
          _definition,
          FontAwesomeIcons.circleInfo,
        ),
        // Only show simple explanation if it's actual content, not a generic error
        if (_simpleExplanation.isNotEmpty && _simpleExplanation != 'Sorry, I could not find information for this term. Please try another word.')
          _buildSection(
            context,
            'Simple Explanation',
            _simpleExplanation,
            FontAwesomeIcons.lightbulb,
          ),
        if (_example.isNotEmpty)
          _buildSection(
            context,
            'Example',
            _example,
            FontAwesomeIcons.bookOpen,
          ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionChip(
              context,
              'Download PDF', // More descriptive label
              FontAwesomeIcons.filePdf,
              () {
                _showSnackBar('Simulating PDF download...');
              },
            ),
            const SizedBox(width: 20),
            _buildActionChip(
              context,
              'Play Audio', // More descriptive label
              FontAwesomeIcons.volumeHigh,
              () {
                _showAudioBottomSheet(context); // Calls the dedicated bottom sheet method
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Helper method to build individual explanation sections (Definition, Simple Explanation, Example).
  Widget _buildSection(BuildContext context, String title, String content, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor, size: 20), // Icon with primary color
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textColor, // Text color for section title
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor, // White background for content block
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.sectionBorderColor, width: 1), // Subtle border
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textColor, // Main text color
                    height: 1.6, // Improved line spacing
                  ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build action chips for PDF/Audio.
  Widget _buildActionChip(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ActionChip(
      avatar: Icon(icon, color: Colors.white, size: 20),
      label: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
      onPressed: onPressed,
      backgroundColor: AppTheme.accentColor, // Accent color for chips
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Pill shape
      elevation: 5,
    );
  }

  /// Shows a bottom sheet for audio playback simulation.
  void _showAudioBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)), // Rounded top corners
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: AppTheme.cardColor, // White background for bottom sheet
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes minimum space
          children: [
            Icon(FontAwesomeIcons.headphonesSimple, size: 60, color: AppTheme.primaryColor),
            const SizedBox(height: 20),
            Text(
              'Playing audio explanation...\n(Integration with Text-to-Speech API)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context), // Close button
              icon: const Icon(Icons.close_rounded),
              label: const Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor, // Red color for close
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}