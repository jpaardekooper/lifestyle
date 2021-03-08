import 'package:lifestylescreening/models/answer_model.dart';

class ScreeningCalc {
  calculateProgress(int value) {
    return 1.0 / value.toDouble();
  }

  calculatePoints(String? category, List<AnswerModel> _userAnswers,
      List<String> _questionAnswer) async {
    int bewegenScore = 0;
    int userCategoryScore = 0;

    for (int i = 0; i < _userAnswers.length; i++) {
      //different score calculation for category bewegen

      if (category == "Bewegen") {
        switch (_userAnswers[i].pointsCalculator) {
          case 0:
            userCategoryScore += _userAnswers[i].points!;
            break;
          case 1:
            int score = (int.tryParse(_questionAnswer[i])! * 0.5).round();
            bewegenScore += score;

            break;
          case 2:
            int score = (int.tryParse(_questionAnswer[i])! * 1).round();
            bewegenScore += score;
            break;
          case 3:
            int score = (int.tryParse(_questionAnswer[i])! * 2).round();
            bewegenScore += score;
            break;
          case 4:
            if (_userAnswers[i].lastAnswer == _questionAnswer[i])
              userCategoryScore += _userAnswers[i].points!;
            break;
        }
      } else {
        switch (_userAnswers[i].pointsCalculator) {
          case 0:
            userCategoryScore += _userAnswers[i].points!;
            break;
          case 1:
            int score = (int.tryParse(_questionAnswer[i])! * 0.5).round();
            userCategoryScore += score;

            break;
          case 2:
            int score = (int.tryParse(_questionAnswer[i])! * 1).round();
            userCategoryScore += score;
            break;
          case 3:
            int score = (int.tryParse(_questionAnswer[i])! * 2).round();
            userCategoryScore += score;
            break;
          case 4:
            if (_userAnswers[i].lastAnswer == _questionAnswer[i])
              userCategoryScore += _userAnswers[i].points!;
            break;
        }
      }
    }
    //if the values are under 30
    if (bewegenScore < 30) {
      userCategoryScore += 1;
    }

    return userCategoryScore;
  }
}
