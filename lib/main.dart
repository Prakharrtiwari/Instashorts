import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instashorts/data/networkServices/api_service.dart';
import 'package:instashorts/data/repository/video_repository.dart';
import 'package:instashorts/presentation/bloc/video_bloc.dart';
import 'package:instashorts/presentation/pages/video_screen.dart';

void main() {
  final dio = Dio();
  final apiService = PexelsApiService(dio);
  final repository = VideoRepository(apiService);

  runApp(
    BlocProvider(
      create: (context) => VideoBloc(repository)..add(FetchVideos()),
      child: MaterialApp(
        home: MainScreen(),
      ),
    ),
  );
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Set Reels as the default tab (index 2)

  // List of pages/screens to display
  final List<Widget> _pages = [
    PlaceholderScreen(icon: Icons.home), // Home
    PlaceholderScreen(icon: Icons.search), // Search
    VideoScreen(), // Reels (now at index 2)
    PlaceholderScreen(icon: Icons.favorite), // Notifications
    PlaceholderScreen(icon: Icons.person), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black, // Translucent black
        selectedItemColor: Colors.white, // Pure white
        unselectedItemColor: Colors.grey, // Pure white
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection), // Use a video icon for Reels
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],

      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final IconData icon;

  PlaceholderScreen({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: 100,
        color: Colors.grey,
      ),
    );
  }
}