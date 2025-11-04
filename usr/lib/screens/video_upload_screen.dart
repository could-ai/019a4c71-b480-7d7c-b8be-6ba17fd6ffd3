import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../models/post.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _video;
  final _captionController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      setState(() {
        _video = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_video == null) return;
    setState(() => _isUploading = true);
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 3));
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final newPost = Post(
      id: DateTime.now().toString(),
      username: auth.currentUser!.username,
      userImage: 'https://via.placeholder.com/50', // Mock user image
      type: PostType.video,
      mediaUrl: _video!.path, // In real app, upload to server and get URL
      caption: _captionController.text,
    );
    postProvider.addPost(newPost);
    setState(() => _isUploading = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video uploaded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
        actions: [
          if (_video != null)
            TextButton(
              onPressed: _isUploading ? null : _uploadVideo,
              child: _isUploading ? const CircularProgressIndicator() : const Text('Share'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickVideo,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _video != null
                    ? const Center(child: Icon(Icons.videocam, size: 50, color: Colors.blue))
                    : const Center(child: Icon(Icons.video_call, size: 50)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Caption'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}