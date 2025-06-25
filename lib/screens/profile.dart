// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/theme/save_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Your Profile'), // Title for the Profile page itself
        centerTitle: false, // Align title to start (left)
        automaticallyImplyLeading:
            false, // Hide back button if this is a root tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch for full width
          children: [
            // User Profile Header - Now Right-Aligned
            Stack(
              alignment:
                  Alignment.bottomRight, // Align stack content to bottom-right
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    right: 20.0,
                  ), // Padding to shift right
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.accentColor,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: AppTheme.cardColor,
                      backgroundImage: const NetworkImage(
                        'https://placehold.co/120x120/E0F7FA/004D40?text=Profile', // Placeholder image
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight, // Align name to right
              child: Text(
                'Priya Sharma',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right, // Ensure text is right-aligned
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight, // Align tagline to right
              child: Text(
                'Financially Empowered & Growing! ✨',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.right, // Ensure text is right-aligned
              ),
            ),
            const SizedBox(height: 24),

            // Financial Snapshot (Mock Data)
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ), // Remove horizontal margin for full width
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Financial Snapshot',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildStatRow(
                      context,
                      'Total Savings:',
                      '₹55,000',
                      Icons.wallet_rounded,
                      AppTheme.successColor,
                    ),
                    _buildStatRow(
                      context,
                      'Monthly Income (Est.):',
                      '₹28,000',
                      FontAwesomeIcons.moneyBillWave,
                      AppTheme.textColor,
                    ),
                    _buildStatRow(
                      context,
                      'Active Goals:',
                      '3',
                      Icons.lightbulb_outline_rounded,
                      AppTheme.accentColor,
                    ),
                    _buildStatRow(
                      context,
                      'Learning Modules Completed:',
                      '7',
                      Icons.menu_book_rounded,
                      AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Achievements/Badges Section
            Align(
              alignment: Alignment
                  .centerLeft, // Keep this section left-aligned for hierarchy
              child: Text(
                'Your Achievements',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3, // 3 badges per row
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 1.0, // Square badges
              children: [
                _buildBadgeCard(
                  context,
                  'First Save',
                  Icons.star_rounded,
                  Colors.amber,
                ),
                _buildBadgeCard(
                  context,
                  'Consistent Saver',
                  Icons.calendar_month_rounded,
                  Colors.blueAccent,
                ),
                _buildBadgeCard(
                  context,
                  'Budgeting Pro',
                  Icons.check_circle_rounded,
                  Colors.green,
                ),
                _buildBadgeCard(
                  context,
                  'New Investor',
                  Icons.trending_up_rounded,
                  Colors.redAccent,
                ),
                _buildBadgeCard(
                  context,
                  'Skill Achiever',
                  FontAwesomeIcons.briefcase,
                  Colors.purple,
                ),
                _buildBadgeCard(
                  context,
                  'Financial Wiz',
                  Icons.auto_awesome_rounded,
                  Colors.deepPurple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Personal Details & Settings Shortcuts
            Align(
              alignment: Alignment.centerLeft, // Keep this section left-aligned
              child: Text(
                'Account & Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  _buildProfileListItem(
                    context,
                    Icons.person_outline_rounded,
                    'Edit Profile',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Edit Profile'),
                      );
                    },
                  ),
                  _buildProfileListItem(
                    context,
                    Icons.security_rounded,
                    'Security & Privacy',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Security & Privacy'),
                      );
                    },
                  ),
                  _buildProfileListItem(
                    context,
                    Icons.language_rounded,
                    'Change Language',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Language Settings'),
                      );
                    },
                  ),
                  _buildProfileListItem(
                    context,
                    Icons.help_outline_rounded,
                    'Help & Support',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        _buildFeatureComingSoonSnackBar('Help & Support'),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Simulate logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logging out...'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(10),
                    ),
                  );
                  // In a real app, this would handle actual logout logic and navigate to login screen
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor, // Red for logout
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileListItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppTheme.primaryColor, size: 28),
          title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: AppTheme.textColor,
          ),
          onTap: onTap,
        ),
        const Divider(
          height: 0,
          indent: 16,
          endIndent: 16,
        ), // Divider for list items
      ],
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
