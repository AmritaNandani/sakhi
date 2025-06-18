import 'package:flutter/material.dart';
import 'package:sakhi/data/data.dart';

class DiscoveryCirclesScreen extends StatelessWidget {
  const DiscoveryCirclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed Scaffold and AppBar here. The parent CommunityHomePage provides it.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // You might want to add a title here if the main app bar doesn't show the screen name
          Text(
            'Explore Circles',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.9, // Adjust as needed
              ),
              itemCount: demoCircles.length,
              itemBuilder: (context, index) {
                final circle = demoCircles[index];
                return _CircleCard(circle: circle);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleCard extends StatelessWidget {
  final Circle circle;

  const _CircleCard({required this.circle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () {
          // Navigate to circle detail page
          // If you navigate to a new route here, that new route would have an AppBar with a back button.
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                circle.icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                circle.name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${circle.members} Members',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                circle.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
