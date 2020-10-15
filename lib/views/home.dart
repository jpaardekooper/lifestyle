import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/chat_tab.dart';
import 'package:lifestylescreening/views/quiz/quiz_screen.dart';
import 'package:lifestylescreening/views/recipe_tab.dart';
import 'package:lifestylescreening/widgets/logo/bottom_navigation_logo.dart';

import 'diary_tab.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    DiaryTab(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    ChatTab(),
    RecipeTab(),
    QuizScreen(),
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
        selectedLabelStyle: TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Colors.red,
          decorationThickness: 5,
        ),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavigationLogo(
              bottomAppIcon: Icons.pause_presentation,
              bottomAppName: 'Dagboek',
              visible: _selectedIndex == 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationLogo(
              bottomAppIcon: Icons.person,
              bottomAppName: 'Challange',
              visible: _selectedIndex == 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationLogo(
              bottomAppIcon: Icons.cake,
              bottomAppName: 'Recepten',
              visible: _selectedIndex == 3,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomNavigationLogo(
              bottomAppIcon: Icons.supervised_user_circle,
              bottomAppName: 'Profile',
              visible: _selectedIndex == 4,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        //    selectedItemColor: Colors.red[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
