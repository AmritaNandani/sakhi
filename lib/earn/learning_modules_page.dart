// lib/pages/learning_modules_page.dart

import 'package:flutter/material.dart';
import 'package:sakhi/theme/save_theme.dart';

class LearningModulesPage extends StatelessWidget {
  const LearningModulesPage({super.key});

  final List<Map<String, String>> _modules = const [
    {
      'title': 'Pricing Your Products/Services',
      'description': 'Learn how to set competitive and profitable prices for your offerings.',
      'icon': '💰',
    },
    {
      'title': 'Basic Hygiene for Food Businesses',
      'description': 'Essential practices to ensure food safety and build customer trust.',
      'icon': '🧼',
    },
    {
      'title': 'Taking Good Product Photos',
      'description': 'Tips and tricks to capture appealing images for online selling.',
      'icon': '📸',
    },
    {
      'title': 'Simple Social Media Marketing',
      'description': 'How to effectively use WhatsApp and Facebook to reach customers.',
      'icon': '📱',
    },
    {
      'title': 'Customer Service Basics',
      'description': 'Develop skills to manage customer queries and build loyalty.',
      'icon': '🗣️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Skill Up! Micro-Learning Modules',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Enhance your business acumen with these quick lessons:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._modules.map((module) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(module['icon']!, style: const TextStyle(fontSize: 24)),
                ),
                title: Text(
                  module['title']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryColor),
                ),
                subtitle: Text(
                  module['description']!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Module "${module['title']}" content coming soon!'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Text(
            'Continuous learning leads to continuous earning!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
