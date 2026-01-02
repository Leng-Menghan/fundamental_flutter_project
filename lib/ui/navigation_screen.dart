import 'package:flutter/material.dart';
import '../models/user.dart';
import '../ui/screens/statistic.dart';
import '../ui/screens/budget_goal.dart';
import '../ui/screens/profile.dart';
import '../ui/screens/home.dart';

class Navigation extends StatefulWidget {
  final User user;
  final ValueChanged<Language> onSelectLanguage;
  const Navigation({super.key, required this.user, required this.onSelectLanguage});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          HomeScreen(user: widget.user),
          StatisticScreen(user: widget.user),
          BudgetGoalScreen(user: widget.user),
          ProfileScreen(
            user: widget.user, 
            onSelectLanguage: widget.onSelectLanguage
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), 
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: const Color.fromARGB(255, 239, 238, 238), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4), 
              ),
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), 
            child: BottomNavigationBar(
              elevation: 10,
              type: BottomNavigationBarType.fixed, 
              selectedItemColor: Color(0xFF438883),
              unselectedItemColor: Colors.grey,
              currentIndex: _currentTabIndex,
              onTap: (index) {
                setState(() => _currentTabIndex = index);
              },
              items: const [
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.house_rounded),
                ), label: 'Home'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.bar_chart_rounded),
                ), label: 'Statistic'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.track_changes),
                ), label: 'Budget Goal'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(Icons.person),
                ), label: 'Profile'),
              ],
            ),
          )
        )
      )
    );
  }
}
