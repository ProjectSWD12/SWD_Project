import 'package:flutter/material.dart';
import 'calendar.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens = [Calendar(), Profile()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffE6F2FF),
        selectedItemColor: Color(0xff005BFF),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: 'Календарь', icon: Icon(Icons.calendar_today)),
          BottomNavigationBarItem(label: 'Профиль', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
