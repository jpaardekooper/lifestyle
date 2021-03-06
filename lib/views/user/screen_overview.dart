import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/views/user/screening/screening_view.dart';
import 'package:lifestylescreening/views/user/overview/show_recent_recipes_tab.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/painter/top_small_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/views/user/home_view.dart' as tabscreen;

class ScreenOverview extends StatelessWidget {
  ScreenOverview({Key? key}) : super(key: key);

  void updatecounterToSettings() {
    tabscreen.counter.value = 3;
  }

  void updatecounterToExperts() {
    tabscreen.counter.value = 2;
  }

  void updatecounterToRecipes() {
    tabscreen.counter.value = 1;
  }

  void updatecounterToGoals() {
    tabscreen.counter.value = 0;
  }

  void startScreeningTest(BuildContext ctx, AppUser user) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreeningView(
          user: user,
          surveyTitle: "Screening test",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              Hero(
                tag: 'background',
                child: CustomPaint(
                  size: Size(size.width, size.height),
                  painter: TopSmallWavePainter(
                    color: ColorTheme.extraLightOrange,
                  ),
                ),
              ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 75),
                    Center(child: H1Text(text: "Overzicht")),
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Text(
                      "Welkom ${_userData.data.userName}",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Fijn dat je weer terug bent. Hieronder is er ",
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "een overzicht van je laatste doelen.",
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Veel plezier!",
                      style: TextStyle(
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width / 2.2,
                          child: Wrap(
                            children: [
                              Text(
                                // ignore: lines_longer_than_80_chars
                                "Om de app nog meer te personaliseren vragen wij u om de screening test af te nemen. Dit is een test dat ongeveer 10 minuten duurt",
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConfirmOrangeButton(
                            onTap: () {
                              startScreeningTest(context, _userData.data);
                            },
                            text: "Screening"),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    // ShowGoalsTab(onTap: updatecounterToGoals),

                    // SizedBox(
                    //   height: size.height * 0.1,
                    // ),

                    ShowRecentRecipesTab(
                        onTap: updatecounterToRecipes, user: _userData.data),

                    SizedBox(
                      height: size.height * 0.1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              H1Text(
                                text: "Raak in contact",
                              ),
                              H1Text(
                                text: "Met een expert",
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => updatecounterToExperts(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "klik hier",
                                style: TextStyle(
                                    fontSize: size.height * 0.021,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                HealthpointIcons.arrowRightIcon,
                                color: Theme.of(context).accentColor,
                                size: size.height * 0.021,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //distance between goals and stay healthy text
                    Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.20),
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: Column(
                        children: [
                          Text(
                            // ignore: lines_longer_than_80_chars
                            "Contact opnemen met een specialist heeft verschillende voordelen. Als u niet zeker bent van de gezondheidsrisico's of zelfs als u gewoon nieuwsgierig bent hoe specialistisch advies u verder kan helpen, kunt u hier terecht.",
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                            color: ColorTheme.extraLightGreen,
                            height: size.height * 0.25,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H1Text(
                              text: "Blijf Fit",
                            ),
                            H1Text(
                              text: "En wordt",
                            ),
                            H1Text(
                              text: "Gezond",
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => updatecounterToSettings(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Meer informatie",
                                style: TextStyle(
                                    fontSize: size.height * 0.024,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                HealthpointIcons.arrowRightIcon,
                                color: Theme.of(context).accentColor,
                                size: size.height * 0.024,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: size.height / 2.1,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width / 2.5,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Text(
                                  """
Een goede leefstijl verkleint het risico op overgewicht en ziekten zoals hart- en vaatziekten, kanker, enzovoort. Een goede leefstijl houdt in: voldoende bewegen, niet roken, geen of weinig alcohol, goede eetgewoontes en voldoende slaap of ontspanning.""",
                                  style:
                                      TextStyle(fontSize: size.height * 0.022),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/images/poppetje1.png',
                                scale: 2.7,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
