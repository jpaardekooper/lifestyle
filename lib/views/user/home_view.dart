import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/page_four_view.dart';
import 'package:lifestylescreening/views/user/page_three_view.dart';
import 'package:lifestylescreening/views/user/page_two_view.dart';
import 'package:lifestylescreening/views/user/recipe_tab.dart';

import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/logo/bottom_navigation_logo.dart';

import 'page_one_view.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PageOne(),
    RecipeTab(),
    PageTwo(),
    PageThree(),
    PageFour(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return SafeArea(
      child: Scaffold(
        body: InheritedDataProvider(
          data: _userData.data,
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
                bottomAppIcon: Icons.adjust,
                bottomAppName: '1',
                visible: _selectedIndex == 0,
              ),
              label: '1',
            ),
            BottomNavigationBarItem(
              icon: BottomNavigationLogo(
                bottomAppIcon: Icons.adjust,
                bottomAppName: 'recepten',
                visible: _selectedIndex == 1,
              ),
              label: 'recepten',
            ),
            BottomNavigationBarItem(
              icon: BottomNavigationLogo(
                bottomAppIcon: Icons.adjust,
                bottomAppName: '3',
                visible: _selectedIndex == 2,
              ),
              label: '3',
            ),
            BottomNavigationBarItem(
              icon: BottomNavigationLogo(
                bottomAppIcon: Icons.adjust,
                bottomAppName: '4',
                visible: _selectedIndex == 3,
              ),
              label: '4',
            ),
            BottomNavigationBarItem(
              icon: BottomNavigationLogo(
                bottomAppIcon: Icons.adjust,
                bottomAppName: '5',
                visible: _selectedIndex == 4,
              ),
              label: '5',
            ),
          ],
          currentIndex: _selectedIndex,
          //    selectedItemColor: Colors.red[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
