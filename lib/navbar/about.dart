// lib/pages/about_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back button if this is a root tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo / Icon Placeholder
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite_rounded, // A heart or empowering icon
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sakhi',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Partner in Financial Independence',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mission Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Mission',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor),
                    ),
                    const Divider(height: 20, thickness: 1.5, color: AppTheme.accentColor),
                    Text(
                      'To empower every woman with the knowledge, tools, and confidence to achieve financial independence and security, enabling her to make informed decisions for herself and her family.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Vision Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Vision',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor),
                    ),
                    const Divider(height: 20, thickness: 1.5, color: AppTheme.accentColor),
                    Text(
                      'A world where every woman is a master of her financial destiny, breaking barriers and inspiring generations through economic freedom and stability.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Version & Legal Info
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor),
                    ),
                    const Divider(height: 20, thickness: 1.5, color: AppTheme.accentColor),
                    _buildInfoRow(context, 'Version:', '1.0.0'),
                    _buildInfoRow(context, 'Last Updated:', 'June 19, 2025'),
                    _buildInfoRow(context, 'Developed by:', 'Your Team Name'), // Replace with your team/company name
                    const SizedBox(height: 16),
                    Text(
                      'Legal & Contact:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildLegalLink(context, 'Privacy Policy', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Privacy Policy'),
                      );
                    }),
                    _buildLegalLink(context, 'Terms of Service', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Terms of Service'),
                      );
                    }),
                    _buildLegalLink(context, 'Contact Us', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Contact Us'),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Thank You Message
            Text(
              'Thank you for being a part of our mission. Together, we can make a difference!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLink(BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(Icons.link_rounded, size: 20, color: AppTheme.accentColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SnackBar _buildFeatureComingSoonSnackBar(String featureName) {
    return SnackBar(
      content: Text('$featureName functionality coming soon!'),
      backgroundColor: AppTheme.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
    );
  }
}
