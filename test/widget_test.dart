// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/repositories/survey_repository_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:lifestylescreening/main.dart';

class MockSurveyRepository extends Mock implements ISurveyRepository {}

void main() {
  MockSurveyRepository mockSurveyRepository;

  setUp(() {
    mockSurveyRepository = MockSurveyRepository();
  });
  test(
    "when called the function getAllQuestions should return list of questions",
    () async {
      when(mockSurveyRepository.getQuestion(1)).thenAnswer((_) => Future.value([
            QuestionModel(
                id: 'gpM4gdOGQhuZ6OXAqckR',
                category: "bewegen",
                order: 1,
                question: "Dit is vraag is"),
            QuestionModel(
                id: 'gpM4gdOGQhuZ6OXAqckR',
                category: "bewegen",
                order: 1,
                question: "Dit is vraag is"),
            QuestionModel(
                id: 'gpM4gdOGQhuZ6OXAqckR',
                category: "bewegen",
                order: 1,
                question: "Dit is vraag is"),
          ]));
      var question = await mockSurveyRepository.getQuestion(1);

      expect(question.length, 3);
    },
  );

  testWidgets('Starting a flutter test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.

    expect(find.text('1'), findsNothing);
  });
}
