import 'package:flutter/material.dart';

enum PostType { photo, video }

class Post {
  final String id;
  final String username;
  final String userImage;
  final PostType type;
  final String mediaUrl;
  final String caption;
  int likes;
  final List<String> comments;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.username,
    required this.userImage,
    required this.type,
    required this.mediaUrl,
    required this.caption,
    this.likes = 0,
    List<String>? comments,
    DateTime? createdAt,
  }) : comments = comments ?? [],
       createdAt = createdAt ?? DateTime.now();
}