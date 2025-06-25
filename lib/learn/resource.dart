// lib/pages/resources_page.dart

import 'package:flutter/material.dart';
import 'package:sakhi/theme/save_theme.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  final List<Map<String, String>> _resources = const [
    {
      'title': 'Budgeting Cheat Sheet',
      'description': 'A quick guide to creating and sticking to your budget.',
      'type': 'PDF',
      'icon': '📄',
    },
    {
      'title': 'Loan Terms Explained',
      'description': 'Simple explanations of common loan terminology.',
      'type': 'PDF',
      'icon': '📚',
    },
    {
      'title': 'Investment Basics Audio',
      'description': 'Listen to fundamental investment concepts on the go.',
      'type': 'Audio (MP3)',
      'icon': '🎧',
    },
    {
      'title': 'Online Safety Infographic',
      'description': 'Visual tips to stay safe from online financial scams.',
      'type': 'Image (PNG)',
      'icon': '🖼️',
    },
    {
      'title': 'Rights of a Woman Investor',
      'description': 'Understand your rights and protections as a woman investor in India.',
      'type': 'PDF',
      'icon': '⚖️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Downloadable Resources',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Enhance your learning with these handy guides and audios:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._resources.map((resource) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                  child: Text(resource['icon']!, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(
                  resource['title']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryColor),
                ),
                subtitle: Text(
                  'Type: ${resource['type']!} | ${resource['description']!}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Simulating download for "${resource['title']}"...'),
                        backgroundColor: AppTheme.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(10),
                      ),
                    );
                    // In a real app, trigger backend download
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero, // Remove default min size
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink tap area
                  ),
                  child: const Text('Download'),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Text(
            'Your financial library, at your fingertips.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
