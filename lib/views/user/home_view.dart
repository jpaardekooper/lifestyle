import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_tab.dart';

import 'package:lifestylescreening/views/user/screen_overview.dart';
import 'package:lifestylescreening/views/user/settings/page_settings.dart';
import 'package:lifestylescreening/views/user/ask_question_view.dart';

import 'package:lifestylescreening/widgets/logo/bottom_navigation_logo.dart';

final ValueNotifier<int> counter = ValueNotifier<int>(0);

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      ScreenOverview(),
      RecipeTab(),
      AskQuestionView(),
      PageSettings(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      counter.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: ValueListenableBuilder(
          builder: (BuildContext context, int value, Widget? child) {
            // This builder will only get called when the counter
            // is updated.
            return _widgetOptions.elementAt(counter.value);
          },
          valueListenable: counter,
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: counter,
            builder: (BuildContext context, int value, Widget? child) {
              return BottomNavigationBar(
                iconSize: MediaQuery.of(context).size.width * 0.05,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: HealthpointIcons.houseIcon,
                      bottomAppName: 'Overzicht',
                      visible: counter.value == 0,
                    ),
                    label: 'overzicht',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: HealthpointIcons.tabIcon,
                      bottomAppName: 'Recepten',
                      visible: counter.value == 1,
                    ),
                    label: 'recepten',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: HealthpointIcons.messageIcon,
                      bottomAppName: 'Vragen',
                      visible: counter.value == 2,
                    ),
                    label: 'stel een vraag',
                  ),
                  BottomNavigationBarItem(
                    icon: BottomNavigationLogo(
                      bottomAppIcon: HealthpointIcons.filterIcon,
                      bottomAppName: 'Gegevens',
                      visible: counter.value == 3,
                    ),
                    label: 'instellingen',
                  ),
                ],
                currentIndex: counter.value,
                //    selectedItemColor: Colors.red[800],
                onTap: _onItemTapped,
              );
            }),
      ),
    );
  }
}
