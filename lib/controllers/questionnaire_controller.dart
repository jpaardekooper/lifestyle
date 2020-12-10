import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
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
  Future<List<QuestionModel>> fetchScreeningQuestion(
      String id, String category) {
    return _questionnaireRepository.getScreeningQuestion(id, category);
  }

  Future<List<CategoryModel>> fetchCategories(String id) {
    return _questionnaireRepository.fetchCategories(id);
  }

//fetch an answer for the question
  Future<List<AnswerModel>> fetchAnswer(String questionId) {
    return _questionnaireRepository.getAnswer(questionId);
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

  Future<void> setQuestion(
      String surveyId, String questionId, Map data, bool _newQuestion) {
    return _questionnaireRepository.setQuestion(
        surveyId, questionId, data, _newQuestion);
  }

  Future<void> removeQuestion(String surveyId, String questionId) {
    return _questionnaireRepository.removeQuestion(surveyId, questionId);
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
}
