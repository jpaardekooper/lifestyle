import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/repositories/interest_repository.dart';
import 'package:lifestylescreening/views/user/tutorial/select_goals_view.dart';
import 'package:lifestylescreening/widgets/appbar/introduction_appbar.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/cards/selected_interest_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class SelectInterestsView extends StatefulWidget {
  SelectInterestsView({Key? key, this.username, this.bmi}) : super(key: key);
  final String? username;
  final BMI? bmi;

  @override
  _SelectInterestsViewState createState() => _SelectInterestsViewState();
}

class _SelectInterestsViewState extends State<SelectInterestsView> {
  final InterestRepository _interestRepository = InterestRepository();
  List<InterestModel>? _interestList;
  List<InterestModel> _selectedInterest = [];

  void signUp() {
    Navigator.of(context).push(
      createRoute(
        SelectGoalsView(
          username: widget.username,
          bmi: widget.bmi,
          selectedInterestList: _selectedInterest,
        ),
      ),
    );
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void toggleSelected(bool value, InterestModel interest) {
    if (value) {
      _selectedInterest.add(interest);
    } else {
      _selectedInterest.remove(interest);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _selectedInterest.clear();
    _interestList!.clear();
  }

  Widget showInterestList() {
    return FutureBuilder<List<InterestModel>>(
      future: _interestRepository.getInterestList(),
      builder: (context, snapshot) {
        _interestList = snapshot.data;

        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _interestList!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (BuildContext context, int index) {
                InterestModel _interest = _interestList![index];
                return SelectedInterestCard(
                  onTap: toggleSelected,
                  interest: _interest,
                );
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
      appBar: introductionAppBar(context, 0.6, false) as PreferredSizeWidget?,
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
                  child: H1Text(text: "Mijn interesses zijn... ")),
            ),
            showInterestList()
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
        height: size.height * 0.15,
        child: TutorialButtons(
          canGoBack: true,
          onPressedBack: goBack,
          onPressedNext: signUp,
        ),
      ),
    );
  }
}
