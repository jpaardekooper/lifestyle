import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/views/admin/dashboard_overview.dart';
import 'package:lifestylescreening/views/admin/messages/messages_overview.dart';
import 'package:lifestylescreening/views/admin/recipe/recipe_view.dart';
import 'package:lifestylescreening/views/admin/survey/survey_view.dart';
import 'package:lifestylescreening/views/user/tutorial/startup.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  String userEmail;

  TabController tabController;
  int active = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4, initialIndex: 0)
      ..addListener(() {
        setState(() {
          active = tabController.index;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.blue,
        appBar: AppBar(
          automaticallyImplyLeading:
              MediaQuery.of(context).size.width < 1300 ? true : false,
          title: Text("DASHBOARD"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    await AuthController().signOut(context);
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Row(
          children: <Widget>[
            MediaQuery.of(context).size.width < 1300
                ? Container()
                : Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(0),
                        height: MediaQuery.of(context).size.height,
                        width: 300,
                        color: Colors.white,
                        child: listDrawerItems(false)),
                  ),
            Container(
              width: MediaQuery.of(context).size.width < 1300
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width - 310,
              child: InheritedDataProvider(
                data: _userData.data,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    DashboardOverview(),
                    MessageOverView(
                      userEmail: _userData.data.email,
                    ),
                    RecipeView(),
                    SurveyView()
                  ],
                ),
              ),
            )
          ],
        ),

        drawer: Padding(
            padding: EdgeInsets.only(top: 56),
            child: Drawer(child: listDrawerItems(true))),
      ),
    );
  }

  Widget listDrawerItems(bool drawerStatus) {
    return ListView(
      children: <Widget>[
        FlatButton(
          color: tabController.index == 0 ? Colors.grey[100] : Colors.white,
          //color: Colors.grey[100],
          onPressed: () {
            tabController.animateTo(0);
            if (drawerStatus) {
              Navigator.pop(context);
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.dashboard),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
        FlatButton(
          color: tabController.index == 1 ? Colors.grey[100] : Colors.white,
          //color: Colors.grey[100],
          onPressed: () {
            tabController.animateTo(1);
            if (drawerStatus) {
              Navigator.pop(context);
            }
          },

          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.dashboard),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Vragen",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
        FlatButton(
          color: tabController.index == 2 ? Colors.grey[100] : Colors.white,
          onPressed: () {
            tabController.animateTo(2);
            if (drawerStatus) {
              Navigator.pop(context);
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.exit_to_app),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Recepten",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
        FlatButton(
          color: tabController.index == 3 ? Colors.grey[100] : Colors.white,
          onPressed: () {
            tabController.animateTo(3);
            if (drawerStatus) {
              Navigator.pop(context);
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 22, bottom: 22, right: 22),
              child: Row(children: [
                Icon(Icons.category),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Survey",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
