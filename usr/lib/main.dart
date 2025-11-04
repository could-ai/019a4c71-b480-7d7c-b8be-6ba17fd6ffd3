import 'package:flutter/material.dart';

void main() {
  runApp(const PixelFlowApp());
}

class PixelFlowApp extends StatelessWidget {
  const PixelFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PixelFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3), // Soft blue as primary
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeFeedScreen(),
    SearchScreen(),
    NewPostScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'New Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          // Stories Section
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockStories.length,
              itemBuilder: (context, index) {
                final story = mockStories[index];
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
                          backgroundImage: NetworkImage(story['image']),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story['username'],
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
          ...mockPosts.map((post) => PostWidget(post: post)),
        ],
      ),
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.post});

  final Map<String, dynamic> post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post['likes'];
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Header
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.post['userImage']),
          ),
          title: Text(
            widget.post['username'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ),
        // Post Image
        Image.network(
          widget.post['image'],
          height: 400,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        // Action Buttons
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : null,
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
                '${_likesCount} likes',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '${widget.post['username']} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: widget.post['caption']),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'View all ${widget.post['comments']} comments',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('your_username'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Placeholder for profile pic
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Posts', '42'),
                      _buildStatColumn('Followers', '1.2K'),
                      _buildStatColumn('Following', '389'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bio and Edit Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bio description here. #photography #travel',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Content Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: mockPosts.length,
              itemBuilder: (context, index) {
                return Image.network(
                  mockPosts[index]['image'],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

// Placeholder screens for other tabs
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Screen - Coming Soon'));
  }
}

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('New Post Screen - Coming Soon'));
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Activity Screen - Coming Soon'));
  }
}

// Mock Data
final List<Map<String, dynamic>> mockStories = [
  {'username': 'your_story', 'image': 'https://via.placeholder.com/100'},
  {'username': 'friend1', 'image': 'https://via.placeholder.com/101'},
  {'username': 'friend2', 'image': 'https://via.placeholder.com/102'},
  {'username': 'friend3', 'image': 'https://via.placeholder.com/103'},
];

final List<Map<String, dynamic>> mockPosts = [
  {
    'username': 'user1',
    'userImage': 'https://via.placeholder.com/50',
    'image': 'https://via.placeholder.com/400x400?text=Post+1',
    'caption': 'Beautiful landscape! #nature #photography',
    'likes': 124,
    'comments': 12,
  },
  {
    'username': 'user2',
    'userImage': 'https://via.placeholder.com/51',
    'image': 'https://via.placeholder.com/400x400?text=Post+2',
    'caption': 'Delicious food! #foodie #yum',
    'likes': 89,
    'comments': 7,
  },
  {
    'username': 'user3',
    'userImage': 'https://via.placeholder.com/52',
    'image': 'https://via.placeholder.com/400x400?text=Post+3',
    'caption': 'Portrait session #portrait #art',
    'likes': 156,
    'comments': 23,
  },
];
