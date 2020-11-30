import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/views/user/tutorial/disclaimer_view.dart';
import 'package:lifestylescreening/views/user/tutorial/signin.dart';
import 'package:lifestylescreening/widgets/cards/disclaimer_card.dart';
import 'package:lifestylescreening/widgets/web/bottom_bar.dart';
import 'package:lifestylescreening/widgets/web/start_survey.dart';

class LandingPageView extends StatefulWidget {
  LandingPageView({Key key}) : super(key: key);

  @override
  _LandingPageViewState createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  List _isHovering = [false, false];

  bool _disclaimerAccepted;

  @override
  void initState() {
    super.initState();
    checkDisclaimerStatus();
  }

  Future checkDisclaimerStatus() async {
    await HelperFunctions.getDisclaimerSharedPreference().then((value) {
      setState(() {
        _disclaimerAccepted = false;
      });
    });
  }

  void onTap() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // hhs groen huisstijl

      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: Container(
          color: const Color.fromRGBO(35, 51, 67, 1),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lifestyle Screening',
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DisclaimerView(),
                          ),
                        );
                      },
                      onHover: (value) {
                        setState(() {
                          _isHovering[0] = value;
                        });
                      },
                      child: Text(
                        'Registreren',
                        style: TextStyle(
                          color: _isHovering[0]
                              ? Color.fromRGBO(0, 178, 205, 1)
                              : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width / 50,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SignIn(),
                          ),
                        );
                      },
                      onHover: (value) {
                        setState(() {
                          _isHovering[1] = value;
                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: _isHovering[1]
                              ? Color.fromRGBO(0, 178, 205, 1)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(158, 167, 0, 1),
          child: Column(
            //  mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (_disclaimerAccepted ?? false) ? StartSurvey() : DisclaimerCard(),
              SizedBox(height: screenSize.height / 3),
              BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
