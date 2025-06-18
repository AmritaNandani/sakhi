import 'package:flutter/material.dart';
import 'package:sakhi/data/data.dart';
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: demoPosts.length,
      itemBuilder: (context, index) {
        final post = demoPosts[index];
        return _FeedPostCard(post: post);
      },
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final Post post;

  const _FeedPostCard({required this.post});

  String _formatTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post.user.avatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _formatTimeAgo(post.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Options for post
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Post Content
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  post.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ],
            if (post.pollOptions != null) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post.pollOptions!.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: entry.value / 100, // Assuming max 100 votes for demo
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${entry.value}%'),
                        const SizedBox(width: 8),
                        Text(entry.key, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            const Divider(height: 24),
            // Actions (Like, Comment, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionItem(
                  context,
                  Icons.favorite_outline,
                  '${post.likes}',
                  () {
                    // Handle like
                  },
                ),
                _buildActionItem(
                  context,
                  Icons.chat_bubble_outline,
                  '${post.comments}',
                  () {
                    // Handle comment
                  },
                ),
                _buildActionItem(
                  context,
                  Icons.share_outlined,
                  '${post.shares}',
                  () {
                    // Handle share
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
      BuildContext context, IconData icon, String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(text, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
