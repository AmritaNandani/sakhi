// lib/pages/micro_courses_page.dart

import 'package:flutter/material.dart';
import 'package:sakhi/theme/save_theme.dart';

class MicroCoursesPage extends StatelessWidget {
  const MicroCoursesPage({super.key});

  final List<Map<String, dynamic>> _courses = const [
    {
      'title': 'Understanding Loans',
      'description': 'Types of loans, interest rates, and smart borrowing tips.',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Mastering UPI Payments',
      'description': 'How to safely and efficiently use UPI for daily transactions.',
      'icon': Icons.payments_rounded,
      'color': Colors.green,
    },
    {
      'title': 'Basics of Saving',
      'description': 'Why saving is important, setting goals, and simple saving methods.',
      'icon': Icons.savings_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'Effective Budgeting',
      'description': 'Learn to track income and expenses to manage your money better.',
      'icon': Icons.sticky_note_2_rounded,
      'color': Colors.purple,
    },
    {
      'title': 'Scam Alerts & Online Safety',
      'description': 'Identify common financial scams and protect yourself online.',
      'icon': Icons.warning_rounded,
      'color': Colors.red,
    },
    {
      'title': 'Investing for Beginners',
      'description': 'Introduction to basic investment options and understanding risk.',
      'icon': Icons.trending_up_rounded,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Micro-Courses: Learn & Grow',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Short, impactful lessons to boost your financial knowledge:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._courses.map((course) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: course['color'].withOpacity(0.1),
                  child: Icon(course['icon'], color: course['color'], size: 28),
                ),
                title: Text(
                  course['title']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primaryColor),
                ),
                subtitle: Text(
                  course['description']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppTheme.textColor),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening course: "${course['title']}" (Content to be loaded from backend)'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                    ),
                  );
                  // In a real app, this would navigate to a CourseDetailPage
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Text(
            'Your journey to financial confidence starts here.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
