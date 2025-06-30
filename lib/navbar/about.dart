import 'package:flutter/material.dart';

// --- App Theme Definition (consistent with previous code for branding) ---
class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink
  static const Color accentColor = Color(0xFFF06292); // Lighter pink/purple
  static const Color cardColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color sectionBgColor = Color(0xFFFFF2D9); // Light yellow (can be changed)
  static const Color iconColor = Color(0xFFE91E63); // Pink for icons
  static const Color successColor = Color(0xFF4CAF50); // Green for checkmarks
  static const Color infoColor = Color(0xFF2196F3); // Blue for info
  static const Color developerTextColor = Color(0xFF616161); // Grey for developer names
}

// --- About Us Page Widget ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive padding
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth > 600 ? 80.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background for a clean look
      appBar: AppBar(
        title: const Text(
          'About Sakhi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0, // No shadow for a modern flat look
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // --- Logo ---
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withOpacity(0.1), // Subtle background for logo
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/bgmini_logo.png', // Your logo asset path
                  fit: BoxFit.contain, // Adjust as needed
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if the image cannot be loaded
                    return Icon(
                      Icons.favorite, // A heart icon as a fallback
                      size: 60,
                      color: AppTheme.primaryColor,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Welcome Text & Tagline ---
            Text(
              'Welcome to Sakhi — Your Financial Friend.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 15),
            Text(
              'Sakhi is a simple, powerful app designed to help women understand and manage their money better. Whether you want to save, plan, or learn — Sakhi is here to guide you, step by step.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.8),
                    height: 1.6, // Line height for better readability
                  ),
            ),

            const SizedBox(height: 40),

            // --- Why Sakhi Section ---
            _buildSectionCard(
              context,
              icon: Icons.lightbulb_outline,
              iconColor: Colors.amber[700]!, // A warm color for the lightbulb icon
              title: 'Why Sakhi?',
              content:
                  'In many rural areas, financial knowledge can be difficult to access. Sakhi bridges this gap by offering tools in local languages, with voice support, so every woman — no matter where she lives or what language she speaks — can become financially confident.',
            ),

            const SizedBox(height: 30),

            // --- With Sakhi, you can: Section ---
            _buildSectionCard(
              context,
              icon: Icons.checklist,
              iconColor: AppTheme.primaryColor,
              title: 'With Sakhi, you can:',
              children: [
                _buildBulletPoint(context, 'Calculate your savings goals', Icons.savings),
                _buildBulletPoint(context, 'Plan for future expenses', Icons.event),
                _buildBulletPoint(context, 'Use voice-to-text if reading is difficult', Icons.mic),
                _buildBulletPoint(context, 'Get help in your own language', Icons.language),
              ],
            ),

            const SizedBox(height: 30),

            // --- Who is it for? Section ---
            _buildSectionCard(
              context,
              icon: Icons.people_alt_outlined,
              iconColor: AppTheme.infoColor, // Blue for target audience icon
              title: 'Who is it for?',
              content:
                  'Sakhi is made especially for women in rural and small-town India. No complex terms. No confusing options. Just simple, clear help — anytime you need it.',
            ),

            const SizedBox(height: 40),

            // --- Call to Action / Closing Statement ---
            Text(
              'Made with love ❤️ to empower every woman in India.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 30),

            // --- Version Info ---
            Text(
              'Version 1.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColor.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 10),

            // --- Contact Us ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Contact us:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textColor.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    // Implement email launch (e.g., using url_launcher package)
                    // For example: launchUrl(Uri.parse('mailto:support@sakhiapp.in'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email support@sakhiapp.in')),
                    );
                  },
                  child: Text(
                    'support@sakhiapp.in',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Developers ---
            Text(
              'Developed by Amrita and Sneha Nandani',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.developerTextColor,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 20), // Padding at the bottom
          ],
        ),
      ),
    );
  }

  // Helper method to build consistent section cards
  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? content,
    List<Widget>? children, // For bullet points
  }) {
    return Card(
      elevation: 8, // More pronounced shadow for cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners
      ),
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: iconColor),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (content != null)
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColor.withOpacity(0.9),
                      height: 1.5,
                    ),
              ),
            if (children != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to build bullet points
  Widget _buildBulletPoint(BuildContext context, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.successColor), // Use a success color for checkmarks
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textColor,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Main App (for demonstration) ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakhi App',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Sets the base color for the app
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto', // A clean, modern font
      ),
      home: const AboutUsPage(),
    );
  }
}