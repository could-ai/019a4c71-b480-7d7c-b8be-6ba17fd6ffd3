import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../widgets/post_widget.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PixelFlow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () {
            // TODO: Open camera for new post
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {
              // TODO: Open direct messages
            },
          ),
        ],
      ),
      body: postProvider.posts.isEmpty
          ? const Center(child: Text('No posts yet. Create your first post!'))
          : ListView(
              children: [
                // Stories Section (simplified)
                Container(
                  height: 100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.orange, Colors.red],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/100?text=Story+$index',
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Story $index',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                // Posts Feed
                ...postProvider.posts.map((post) => PostWidget(post: post, currentUser: currentUser)),
              ],
            ),
    );
  }
}