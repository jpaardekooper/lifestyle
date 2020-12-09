import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lifestylescreening/widgets/text/h3_orange_text.dart';

class PageSettings extends StatefulWidget {
  PageSettings({Key key}) : super(key: key);

  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  Color borderlineColor = Color.fromARGB(69, 106, 103, 1);
  bool isSwitched = false;
  bool isSwitchedNotification = false;

  Widget SettingsTitle(String text) {
    return Container(
      // Width is hier niet nodig
      width: double.infinity,
      child: Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
    );
  }

  Widget SettingsUserInfoField(String text, String value, String format) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 30.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 4, color: Colors.black),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(text,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 5,
            child: Text(value.toString() + format,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget SettingsCompanionApp(Color color, Color textcolor, String buttonName) {
    return Expanded(
      flex: 4,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(30.0)),
        height: 125,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(buttonName,
                        style: TextStyle(
                          color: textcolor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Expanded(
                    flex: 6,
                    child: Icon(Icons.star, color: Colors.green[500]),
                  ),
                ],
              ),
            ),
            FlatButton(
              color: Colors.white,
              textColor: Colors.pink,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              onPressed: () {
                /*...*/
              },
              child: Text(
                "connect",
                style: TextStyle(fontSize: 17.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: H1Text(
          text: "Settings",
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          TextButton(
            child: H3OrangeText(text: "Edit"),
            onPressed: null,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomPaint(
                  size: Size(size.width, size.height),
                  painter: BottomLargeWavePainter(
                    color: ColorTheme.extraLightOrange,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                /// THIS CONTAINER KEEPS EVERYTHING INLINE
                Container(
                  padding: EdgeInsets.all(30.0),

                  /// HEADER OF BLOCK
                  // Als je ruimte tussen de widgets in de column wilt hebben kan je er een SizedBox tussen doen en de height aanpassen
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsTitle("Personal settings"),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        // Kan hier IntroGreyText gebruiken, kan bij elke Text widget die je aanroept, moet je even kijken welke erbij past
                        child:
                            Text("View and adjust your personal settings here.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey,
                                )),
                      ),

                      /// ORANGE BLOCK
                      Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFF4E6),
                            borderRadius: BorderRadius.circular(30.0)),
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(_userData.data.userName,
                                  // Voor deze textStyle moet je ff kijken want ik denk dat hier H3OrangeText te vaag voor is en we hebben verder geen goede oranje tekst
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            Spacer(flex: 2),
                            Expanded(
                              flex: 4,
                              child: Text("35 year old",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),

                      /// Column with All user infos
                      Column(
                        children: [
                          SettingsUserInfoField(
                              "Weight", _userData.data.weight.toString(), "KG"),
                          SettingsUserInfoField(
                              "Length", _userData.data.height.toString(), "CM"),
                          SettingsUserInfoField(
                              "Date of birth", "", "28-05-1969"),
                          SettingsUserInfoField(
                              "Sex", "", _userData.data.gender.toString()),
                        ],
                      ),

                      /// Column with notification settings
                      Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 70),
                              child: SettingsTitle("Notification settings")),

                          // TIJDELIJK OM EFFE TE KIJKEN HOE WAT
                          Container(
                            padding: EdgeInsets.only(bottom: 15, top: 30.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 4, color: Colors.black),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text("Enable push notifications",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FlutterSwitch(
                                    value: isSwitchedNotification,
                                    onToggle: (value) {
                                      setState(() {
                                        isSwitchedNotification = value;
                                      });
                                    },
                                    activeColor: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(bottom: 15, top: 30.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 4, color: Colors.black),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text("Only in-app-messages",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: FlutterSwitch(
                                    value: isSwitched,
                                    onToggle: (value) {
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    },
                                    activeColor: Colors.green[900],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 70),
                                  child: SettingsTitle(
                                      "Collect data \nfrom other apps")),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 30),
                                child: Text(
                                    "Track activities better with data from apps like Apple health and Strave.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey,
                                    )),
                              ),
                            ],
                          ),

                          /// ORANGE BLOCK
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SettingsCompanionApp(
                                  Colors.red[100], Colors.red, "Apple health"),
                              Spacer(
                                flex: 1,
                              ),
                              SettingsCompanionApp(
                                  Colors.orange[100], Colors.red, "Strava"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
