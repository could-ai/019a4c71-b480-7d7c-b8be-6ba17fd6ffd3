import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'auth_provider.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  PostProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _posts = [
      Post(
        id: '1',
        username: 'user1',
        userImage: 'https://via.placeholder.com/50',
        type: PostType.photo,
        mediaUrl: 'https://via.placeholder.com/400x400?text=Photo+1',
        caption: 'Beautiful landscape! #nature #photography',
        likes: 124,
        comments: ['Nice!', 'Amazing view'],
      ),
      Post(
        id: '2',
        username: 'user2',
        userImage: 'https://via.placeholder.com/51',
        type: PostType.video,
        mediaUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        caption: 'Funny video! #fun #bunny',
        likes: 89,
        comments: ['LOL', 'So cute'],
      ),
    ];
    notifyListeners();
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void deletePost(String postId, User currentUser) {
    _posts.removeWhere((post) => post.id == postId && post.username == currentUser.username);
    notifyListeners();
  }

  void likePost(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.likes++;
    notifyListeners();
  }

  void unlikePost(String postId) {
    final post = _posts.firstWhere((p) => p.id == postId);
    if (post.likes > 0) post.likes--;
    notifyListeners();
  }
}