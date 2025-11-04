import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../models/post.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  File? _image;
  final _captionController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_image == null) return;
    setState(() => _isUploading = true);
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final newPost = Post(
      id: DateTime.now().toString(),
      username: auth.currentUser!.username,
      userImage: 'https://via.placeholder.com/50', // Mock user image
      type: PostType.photo,
      mediaUrl: _image!.path, // In real app, upload to server and get URL
      caption: _captionController.text,
    );
    postProvider.addPost(newPost);
    setState(() => _isUploading = false);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo uploaded successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
        actions: [
          if (_image != null)
            TextButton(
              onPressed: _isUploading ? null : _uploadPhoto,
              child: _isUploading ? const CircularProgressIndicator() : const Text('Share'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Center(child: Icon(Icons.add_photo_alternate, size: 50)),
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