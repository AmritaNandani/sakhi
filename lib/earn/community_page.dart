// lib/pages/community_page.dart
import 'package:sakhi/theme/save_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect & Grow',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.group_rounded, color: AppTheme.primaryColor),
              title: Text(
                'Peer Learning Groups',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Join groups based on your skills and interests to share tips.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Peer groups feature coming soon!'),
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
              leading: Icon(FontAwesomeIcons.solidComments, color: AppTheme.primaryColor),
              title: Text(
                'Ask an Expert Forum',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Get advice from experienced entrepreneurs and mentors.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Expert forum coming soon!'),
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
              leading: Icon(Icons.videocam_rounded, color: AppTheme.primaryColor),
              title: Text(
                'Virtual Workshops & Meetups',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Attend sessions with successful women entrepreneurs.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Virtual events coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              'Together, we build a stronger future.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
