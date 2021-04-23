import 'package:flutter/material.dart';
import 'package:imgur_like/pages/account.dart';
import 'package:imgur_like/pages/home.dart';
import 'package:imgur_like/pages/search.dart';

class BottomNavBarPage extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;
  static const double IconSize = 200;
  static List<Widget> _widgetOptions = [
    home(),
    searchPage(),
    accountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.blueAccent,
        selectedItemColor: Colors.redAccent,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}