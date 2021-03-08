import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/repositories/goals_repository.dart';
import 'package:lifestylescreening/views/user/tutorial/signup.dart';
import 'package:lifestylescreening/widgets/appbar/introduction_appbar.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/cards/selected_goal_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class SelectGoalsView extends StatefulWidget {
  SelectGoalsView({Key? key, this.username, this.bmi, this.selectedInterestList})
      : super(key: key);
  final String? username;
  final BMI? bmi;
  final List<InterestModel>? selectedInterestList;

  @override
  _SelectGoalsViewState createState() => _SelectGoalsViewState();
}

class _SelectGoalsViewState extends State<SelectGoalsView> {
  final GoalsRepository _goalsRepository = GoalsRepository();
  List<GoalsModel>? _goalsList = [];
  List<GoalsModel> _selectedGoals = [];

  void signUp() {
    Navigator.of(context).push(
      createRoute(
        SignUp(
            username: widget.username,
            bmi: widget.bmi,
            selectedInterest: widget.selectedInterestList,
            goalsList: _selectedGoals),
      ),
    );
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void toggleSelected(bool value, GoalsModel _goals) {
    if (value) {
      _selectedGoals.add(_goals);
    } else {
      _selectedGoals.remove(_goals);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _goalsList!.clear();
    _selectedGoals.clear();
  }

  Widget loadGoalsList() {
    return FutureBuilder<List<GoalsModel>>(
      future: _goalsRepository.getGoalsList(),
      builder: (context, snapshot) {
        _goalsList = snapshot.data;

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _goalsList!.length,
              itemBuilder: (BuildContext context, int index) {
                GoalsModel _goals = _goalsList![index];
                return SelectedGoalCard(onTap: toggleSelected, goal: _goals);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: introductionAppBar(context, 0.8, false) as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.height * 0.04),
              child: Hero(
                  tag: 'intro-text',
                  child: H1Text(text: "Mijn doel(en) zijn...")),
            ),
            loadGoalsList()
          ],
        ),
      ),
      //adding blue color to a container
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorTheme.darkGreen,
              width: 2.5,
            ),
          ),
          color: ColorTheme.extraLightGreen,
        ),
        height: MediaQuery.of(context).size.height * 0.15,
        child: TutorialButtons(
          canGoBack: true,
          onPressedBack: goBack,
          onPressedNext: signUp,
        ),
      ),
    );
  }
}
