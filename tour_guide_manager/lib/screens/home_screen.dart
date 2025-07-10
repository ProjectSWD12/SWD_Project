import 'package:flutter/material.dart';
import 'package:tour_guide_manager/colors.dart';
import 'applications.dart';
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
    const Applications(),
    const Profile(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.darkBlue,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                label: 'Календарь',
                icon: Icon(Icons.calendar_today),
              ),
              const BottomNavigationBarItem(
                label: 'Заявки',
                icon: Icon(Icons.notifications),
              ),
              const BottomNavigationBarItem(
                label: 'Профиль',
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
