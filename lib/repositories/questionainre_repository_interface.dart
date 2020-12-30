import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

abstract class IQuestionnaireRepository {
  //user functions

  //get question for user for DTD test
  Future<List<QuestionModel>> getDTDQuestion();

  //get question for user for Screening test
  Future<List<QuestionModel>> getScreeningQuestion(String category);

  Future<List<SurveyModel>> fetchCategories(String id);

  //get options for question
  Future<List<AnswerModel>> getAnswer(String category, String questionId);

  //admin functions
  Stream<QuerySnapshot> streamQuestions(String id);

  List<QuestionModel> fetchQuestions(QuerySnapshot snapshot);

  Stream<QuerySnapshot> streamAnswers(String id, String questionId);

  List<AnswerModel> fetchAnswers(AsyncSnapshot<QuerySnapshot> snapshot);

//add
  Future<void> setQuestion(CategoryModel category, String questionId, Map data,
      int totalQuestions, bool _newQuestion);
//delete question
  Future<void> removeQuestion(
      CategoryModel category, String questionId, int totalQuestions);
// add answer
  Future<void> setAnswer(String surveyID, String questionId, String answerId,
      Map data, bool insertNewAnswer);
//delete answer
  Future<void> removeAnswerFromQuestion(
      String surveyId, String questionId, String answerId);

  //Add User Survey Data to firebase
  Future<void> setUserSurveyAnswers(
    String surveyTitle,
    AppUser user,
    String category,
    int index,
    Map surveyData,
    Map data,
  );

  Future<void> setSurveyToFalse(
      String surveyTitle, AppUser user, SurveyResultModel surveyResult);

  Future<List<SurveyResultModel>> checkSurveyResult(
      String surveyTitle, String email);
}
