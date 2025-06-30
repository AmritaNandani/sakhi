import 'package:flutter/material.dart';

// --- Data Models ---

class User {
  final String id;
  final String name;
  final String avatarUrl;

  User({required this.id, required this.name, required this.avatarUrl});
}

class Post {
  final String id;
  final User user;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final DateTime timestamp;
  final Map<String, int>? pollOptions; // Option text and vote count

  Post({
    required this.id,
    required this.user,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    required this.timestamp,
    this.pollOptions,
  });
}

class Comment {
  final String id;
  final User user;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamp,
  });
}

class Circle {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int members;

  Circle({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.members,
  });
}

class Event {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final int attendees;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.attendees,
  });
}

class Resource {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final String link;

  Resource({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.link,
  });
}

// --- Demo Data ---

final User currentUser =
    User(id: 'u1', name: 'Sophia Grace', avatarUrl: 'https://placehold.co/100x100/A088FF/FFFFFF?text=SG');

final User priya =
    User(id: 'u2', name: 'Priya Raj', avatarUrl: 'https://placehold.co/100x100/FFC0CB/000000?text=PR');
final User aisha =
    User(id: 'u3', name: 'Aisha Khan', avatarUrl: 'https://placehold.co/100x100/90EE90/000000?text=AK');
final User emily =
    User(id: 'u4', name: 'Emily White', avatarUrl: 'https://placehold.co/100x100/ADD8E6/000000?text=EW');

final List<Post> demoPosts = [
  Post(
    id: 'p1',
    user: priya,
    content:
        "Just finished my morning yoga! Feeling so centered and ready for the day. Any tips for staying motivated on rest days? #WellnessWednesday #YogaLife",
    imageUrl: "assets/images/yoga.png",
    likes: 150,
    comments: 25,
    shares: 5,
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  Post(
    id: 'p2',
    user: currentUser,
    content:
        "Excited to announce our next 'Career Climb & Thrive' workshop on 'Negotiating Your Worth'! Details coming soon. What topics would you like to see covered?",
    likes: 210,
    comments: 40,
    shares: 15,
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Post(
    id: 'p3',
    user: aisha,
    content: "New Poll: What's your biggest challenge in balancing career and personal life right now?",
    pollOptions: {
      'Time Management': 45,
      'Setting Boundaries': 30,
      'Dealing with Guilt': 15,
      'Energy Levels': 10,
    },
    likes: 80,
    comments: 80, // Comments representing poll discussions
    shares: 10,
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Post(
    id: 'p4',
    user: emily,
    content:
        "Reading 'The Power of Habit' and it's truly changing my perspective! Highly recommend. What are you currently reading? #BookClub #PersonalGrowth",
    imageUrl: 'assets/images/reading.png',
    likes: 90,
    comments: 18,
    shares: 3,
    timestamp: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

final List<Circle> demoCircles = [
  Circle(
      id: 'c1',
      name: 'Career Climb & Thrive',
      description: 'Discussions on professional growth, leadership, and work-life balance.',
      icon: Icons.work_outline,
      members: 1250),
  Circle(
      id: 'c2',
      name: 'Mindful Living',
      description: 'For all things wellness: mental health, fitness, and healthy habits.',
      icon: Icons.spa_outlined,
      members: 980),
  Circle(
      id: 'c3',
      name: 'Creative Corner',
      description: 'Share your artistic endeavors, crafts, and creative inspiration.',
      icon: Icons.palette_outlined,
      members: 720),
  Circle(
      id: 'c4',
      name: 'Parenting & Family',
      description: 'Support and advice for navigating the joys and challenges of family life.',
      icon: Icons.family_restroom_outlined,
      members: 1500),
  Circle(
      id: 'c5',
      name: 'Financial Freedom',
      description: 'Tips and discussions on personal finance, investing, and wealth building.',
      icon: Icons.currency_exchange_outlined,
      members: 600),
];

final List<Event> demoEvents = [
  Event(
    id: 'e1',
    title: 'Negotiating Your Worth Workshop',
    date: 'July 20, 2025',
    time: '2:00 PM IST',
    location: 'Online (Zoom)',
    imageUrl: 'assets/images/workshop.png',
    attendees: 180,
  ),
  Event(
    id: 'e2',
    title: 'Mindful Meditation Session',
    date: 'July 25, 2025',
    time: '7:00 AM IST',
    location: 'Online (Google Meet)',
    imageUrl: 'assets/images/meditation.png',
    attendees: 95,
  ),
  Event(
    id: 'e3',
    title: 'Local Book Club Meetup',
    date: 'August 5, 2025',
    time: '6:00 PM IST',
    location: 'Community Cafe, Sector 18, Patna',
    imageUrl: 'assets/images/bookclub.png',
    attendees: 30,
  ),
];

final List<Resource> demoResources = [
  Resource(
    id: 'r1',
    title: '5 Simple Practices for Daily Mindfulness',
    category: 'Mindful Living',
    description: 'Easy-to-follow techniques to incorporate mindfulness into your everyday routine.',
    imageUrl: 'https://placehold.co/600x300/FBF6F3/383433?text=Mindfulness+Article',
    link: 'https://example.com/mindfulness',
  ),
  Resource(
    id: 'r2',
    title: 'Building a Strong Professional Network',
    category: 'Career & Business',
    description: 'Strategies for effective networking and building valuable connections.',
    imageUrl: 'https://placehold.co/600x300/F56D53/FFFFFF?text=Networking+Guide',
    link: 'https://example.com/networking',
  ),
  Resource(
    id: 'r3',
    title: 'Healthy Recipes for Busy Women',
    category: 'Wellness',
    description: 'Quick and nutritious recipes perfect for your hectic schedule.',
    imageUrl: 'https://placehold.co/600x300/90EE90/000000?text=Healthy+Recipes',
    link: 'https://example.com/recipes',
  ),
];
