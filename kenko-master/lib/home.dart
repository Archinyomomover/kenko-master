import 'package:flutter/material.dart';
import 'package:kenko/mappage.dart'; // Make sure this import exists

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Add your page list here – only Map is implemented, rest are placeholders
  static final List<Widget> _widgetOptions = <Widget>[
    Container(),            // Home (not yet implemented)
    Container(),            // Dashboard (not yet implemented)
    Container(),            // Add (not yet implemented)
    FreeMapScreen(),        // ✅ Map page you built
    Container(),            // Mental (not yet implemented)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'), // ✅ Map
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Mental'),
        ],
      ),
    );
  }
}
