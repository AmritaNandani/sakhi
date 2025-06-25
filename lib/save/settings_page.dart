// lib/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:sakhi/theme/save_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.language_rounded, color: AppTheme.primaryColor),
              title: Text(
                'Language Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'English (Tap to change)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Language settings coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_active_rounded, color: AppTheme.primaryColor),
              title: Text(
                'Notification Preferences',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Manage your daily reminders and alerts',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notification settings coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor),
              title: Text(
                'About App',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                // Show app info or navigate to an About page
              },
            ),
          ),
          const Spacer(), // Pushes content to the top
          Center(
            child: Text(
              'Empowering women, one save at a time.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
