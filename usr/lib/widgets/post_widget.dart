import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.post, required this.currentUser});

  final Post post;
  final User? currentUser;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.post.type == PostType.video) {
      _videoController = VideoPlayerController.network(widget.post.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (_isLiked) {
      postProvider.likePost(widget.post.id);
    } else {
      postProvider.unlikePost(widget.post.id);
    }
  }

  void _toggleVideoPlay() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
    });
    if (_isVideoPlaying) {
      _videoController?.play();
    } else {
      _videoController?.pause();
    }
  }

  Future<void> _downloadVideo() async {
    if (widget.post.type == PostType.video) {
      await FlutterDownloader.enqueue(
        url: widget.post.mediaUrl,
        savedDir: '/storage/emulated/0/Download', // Android path, adjust for iOS
        showNotification: true,
        openFileFromNotification: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download started')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.post.userImage),
            ),
            title: Text(
              widget.post.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: widget.currentUser?.username == widget.post.username
                ? IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  )
                : null,
          ),
          // Post Media
          GestureDetector(
            onTap: widget.post.type == PostType.video ? _toggleVideoPlay : null,
            child: Hero(
              tag: widget.post.id,
              child: widget.post.type == PostType.photo
                  ? Image.network(
                      widget.post.mediaUrl,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 400,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    )
                  : _videoController != null && _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : Container(
                          height: 400,
                          color: Colors.black,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
            ),
          ),
          // Action Buttons
          Row(
            children: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(_isLiked),
                    color: _isLiked ? Colors.red : null,
                  ),
                ),
                onPressed: _toggleLike,
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              if (widget.post.type == PostType.video)
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: _downloadVideo,
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
          // Likes and Comments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.post.likes} likes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '${widget.post.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.post.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'View all ${widget.post.comments.length} comments',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false).deletePost(widget.post.id, widget.currentUser!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}