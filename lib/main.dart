import 'package:flutter/material.dart';
import 'package:thepetnest/Screens/HomePage.dart';
import 'package:thepetnest/Screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Add placeholder widgets or the actual screens here
    Homepage(),  // Placeholder for Pickupdelivery screen           // Placeholder for Mywallet screen
    Homescreen(),          // Placeholder for ProfileScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // This now references the list with valid elements
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(2, (index) {
          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: _selectedIndex == index ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Image.asset(
                _getImageForIndex(index),
                color: _selectedIndex == index ? Colors.blue : Colors.grey,
                height: 24, // Adjust the height as needed
                width: 24,  // Adjust the width as needed
              ),
            ),
            label: _getLabelForIndex(index),
          );
        }),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // Required to show all icons and labels
      ),
    );
  }

  String _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return 'assets/images/home.png';
      case 1:
        return 'assets/images/profile.png';
      default:
        return 'assets/images/home.png';
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Profile';
      default:
        return '';
    }
  }
}
