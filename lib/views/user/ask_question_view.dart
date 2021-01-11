import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/chat_controller.dart';
import 'package:lifestylescreening/controllers/survey_controller.dart';
import 'package:lifestylescreening/models/admin_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/views/user/chat/chat_tab.dart';
import 'package:lifestylescreening/views/user/screening/screening_view.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/buttons/ghost_grey_button.dart';
import 'package:lifestylescreening/widgets/buttons/ghost_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/top_small_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/intro_light_grey_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

class AskQuestionView extends StatefulWidget {
  AskQuestionView({Key key}) : super(key: key);

  @override
  _AskQuestionViewState createState() => _AskQuestionViewState();
}

class _AskQuestionViewState extends State<AskQuestionView> {
  final ChatController _chatController = ChatController();
  String email;

  Widget showLastSurveyResult() {
    return FutureBuilder<List<SurveyResultModel>>(
      //fetching data from the corresponding questionId
      future: SurveyController().getLastSurveyResult(email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("geen data gevonden");
        } else {
          final List<SurveyResultModel> _survey = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1Text(text: "Hoe goed zorg je voor jezelf?"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              LifestyleText(
                  text:
                      // ignore: lines_longer_than_80_chars
                      "In dit deel van het onderzoek laten we je zien hoe goed je voor jezelf zorgt. We geven dit aan met een puntenaantal per onderdeel (bewegen, roken, alcohol, voeding en ontspanning). Het einddoel is om zo min mogelijk punten te behalen. Hoe meer punten, hoe meer ruimte voor verbetering."),
              SizedBox(
                height: 10,
              ),
              LifestyleText(text: "Uw scores zijn:"),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _survey.first.categories.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 20,
                        child: BodyText(text: _survey.first.categories[index]),
                      ),
                      LifestyleText(
                          text: "${_survey.first.points_per_category[index]}")
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              BodyText(
                  text: "Totaal aantal punten \t ${_survey.first.total_points}")
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    email = _userData.data.email;
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  H1Text(text: "Kom in contact met "),
                  H1Text(text: "Specialisten"),
                  SizedBox(height: 10),
                  IntroLightGreyText(
                      text:
                          // ignore: lines_longer_than_80_chars
                          "Contact opnemen met een expert heeft verschillende voordelen. Als je onzeker bent over een gezondheidsrisico of als je nieuwsgierig bent over hoe het advies van een expert je verder kan helpen, kan dat hier worden gedaan"),
                  SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/doctor.jpg',
                      height: MediaQuery.of(context).size.height / 4,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  SizedBox(height: 40),
                  showLastSurveyResult(),
                  SizedBox(height: 40),
                  H1Text(text: "Een gepersonaliseerde health scan"),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: ConfirmOrangeButton(
                      text: "Start scan",
                      onTap: () => {
                        Navigator.of(context).push(
                          createRoute(
                            ScreeningView(
                              user: _userData.data,
                              surveyTitle: "Screening test",
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                  SizedBox(height: 75),
                  H1Text(text: "Beschikbare experts"),
                  FutureBuilder<List<AdminModel>>(
                    future: _chatController.getExperts(),
                    builder: (BuildContext context, snapshot) {
                      List<AdminModel> _adminList = snapshot.data;
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _adminList.length,
                          itemBuilder: (BuildContext context, index) {
                            AdminModel _adminModel = _adminList[index];
                            return ExpertOptions(
                                adminModel: _adminModel,
                                email: _userData.data.email);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpertOptions extends StatelessWidget {
  ExpertOptions({this.adminModel, this.email});

  final AdminModel adminModel;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: adminModel.medical
            ? const Color(0xFFEFFAF6)
            : const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                // backgroundImage: NetworkImage(adminModel.image),
                child: Icon(Icons.person),
                backgroundColor: adminModel.medical
                    ? const Color(0xFFA1CFBE)
                    : const Color(0xFFFFDFB9),
              ),
              SizedBox(height: 15),
              IntroGreyText(
                text: adminModel.name,
              ),
              BodyText(text: adminModel.profession),
            ],
          ),
          Spacer(),
          adminModel.medical
              ? GhostGreyButton(
                  text: "Message",
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatTab(
                          model: adminModel,
                          email: email,
                        ),
                      ),
                    ),
                  },
                )
              : GhostOrangeButton(
                  text: "Message",
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatTab(
                          model: adminModel,
                          email: email,
                        ),
                      ),
                    ),
                  },
                ),
        ],
      ),
    );
  }
}
