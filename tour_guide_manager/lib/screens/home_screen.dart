import 'package:flutter/material.dart';
import 'calendar.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    const Calendar(),
    const Profile(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6F2FF),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xff005BFF),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Календарь',
                  icon: Icon(Icons.calendar_today)
                ),
                BottomNavigationBarItem(
                  label: 'Профиль',
                  icon: Icon(Icons.person)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
