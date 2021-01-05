import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/repositories/questionnaire_repository.dart';
import 'package:lifestylescreening/repositories/questionainre_repository_interface.dart';

class QuestionnaireController {
  final IQuestionnaireRepository _questionnaireRepository =
      QuestionnaireRepository();

//Fetch a question for the user
  Future<List<QuestionModel>> fetchDTDQuestion() {
    return _questionnaireRepository.getDTDQuestion();
  }

  //Fetch a question for the user
  Future<List<QuestionModel>> fetchScreeningQuestion(String category) {
    return _questionnaireRepository.getScreeningQuestion(category);
  }

  Future<List<SurveyModel>> fetchCategories(String id) {
    return _questionnaireRepository.fetchCategories(id);
  }

//fetch an answer for the question
  Future<List<AnswerModel>> fetchAnswer(String category, String questionId) {
    return _questionnaireRepository.getAnswer(category, questionId);
  }

  //fetch an answer for the question
  Future<List<AnswerModel>> fetchDTDAnswer(String questionId) {
    return _questionnaireRepository.getDTDAnswer(questionId);
  }

  Stream<QuerySnapshot> streamQuestion(String id) {
    return _questionnaireRepository.streamQuestions(id);
  }

  List<QuestionModel> fetchQuestions(QuerySnapshot snapshot) {
    return _questionnaireRepository.fetchQuestions(snapshot);
  }

  Stream<QuerySnapshot> streamAnswers(String id, String questionId) {
    return _questionnaireRepository.streamAnswers(id, questionId);
  }

  List<AnswerModel> fetchAnswers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return _questionnaireRepository.fetchAnswers(snapshot);
  }

  Future<void> setQuestion(CategoryModel category, String questionId, Map data,
      int totalQuestions, bool _newQuestion) {
    return _questionnaireRepository.setQuestion(
        category, questionId, data, totalQuestions, _newQuestion);
  }

  Future<void> removeQuestion(
      CategoryModel category, String questionId, int totalQuestions) {
    return _questionnaireRepository.removeQuestion(
        category, questionId, totalQuestions);
  }

  Future<void> setAnswer(String surveyID, String questionId, String answerId,
      Map data, bool insertNewAnswer) {
    return _questionnaireRepository.setAnswer(
        surveyID, questionId, answerId, data, insertNewAnswer);
  }

  Future<void> removeAnswerFromQuestion(
      String parentId, String questionDoc, String answerDoc) {
    return _questionnaireRepository.removeAnswerFromQuestion(
        parentId, questionDoc, answerDoc);
  }

  Future<void> setUserSurveyAnswer(
      String surveyTitle,
      AppUser user,
      String category,
      int index,
      Map surveyData,
      Map data,
      bool lastSurveyCategory) {
    return _questionnaireRepository.setUserSurveyAnswers(
        surveyTitle, user, category, index, surveyData, data);
  }

  Future<void> checkSurveyResult(String surveyTitle, String email) {
    return _questionnaireRepository.checkSurveyResult(surveyTitle, email);
  }

  Future<void> setSurveyToFalse(
      String surveyTitle, AppUser user, SurveyResultModel surveyResult) {
    return _questionnaireRepository.setSurveyToFalse(
        surveyTitle, user, surveyResult);
  }

  Future<String> createDTDid() {
    return _questionnaireRepository.createDTDid();
  }

  Future<void> setDTDSurveyResults(String id, Map data) {
    return _questionnaireRepository.setDTDSurveyResults(id, data);
  }
}
