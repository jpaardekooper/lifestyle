import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/repositories/questionainre_repository_interface.dart';
import 'package:uuid/uuid.dart';

class QuestionnaireRepository implements IQuestionnaireRepository {
  @override
  Future<List<QuestionModel>> getDTDQuestion() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc('6rkGdqflHFzlbrPvDXCu')
        .collection("questions")
        .orderBy('order', descending: false)
        //    .where('order', isEqualTo: questionOrder)
        //  .limit(1)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return QuestionModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<QuestionModel>> getScreeningQuestion(String? category) async {
    // List<QuestionModel> screeningList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("category", isEqualTo: category)
        .get()
        .then((value) {
      return FirebaseFirestore.instance
          .collection("categories")
          .doc(value.docs.first.id)
          .collection("questions")
          .orderBy("order", descending: false)
          .get();
    });

    return snapshot.docs.map((DocumentSnapshot doc) {
      return QuestionModel.fromSnapshot(doc);
    }).toList();

    // screeningList.sort((a, b) => a.order.compareTo(b.order));

    //  return screeningList;
  }

  @override
  Future<List<SurveyModel>> fetchCategories(String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("surveys")
        .where("title", isEqualTo: id)
        //   .doc(id)
        //.collection("categories")
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return SurveyModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<AnswerModel>> getAnswer(String? category, String? id) async {
    // List<AnswerModel> _answerList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("category", isEqualTo: category)
        .get()
        .then((value) {
      return FirebaseFirestore.instance
          .collection("categories")
          .doc(value.docs.first.id)
          .collection("questions")
          .doc(id)
          .collection('answers')
          .orderBy('order', descending: false)
          .get();
    });

    return snapshot.docs.map((DocumentSnapshot doc) {
      return AnswerModel.fromSnapshot(doc);
    }).toList();

    //  return _answerList;
  }

  @override
  Future<List<AnswerModel>> getDTDAnswer(String? id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc('6rkGdqflHFzlbrPvDXCu')
        .collection("questions")
        .doc(id)
        .collection('answers')
        .orderBy('order', descending: false)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return AnswerModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamQuestions(String? id) {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(id)
        .collection('questions')
        .orderBy('order', descending: false)
        .snapshots();
  }

  @override
  List<QuestionModel> fetchQuestions(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return QuestionModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamAnswers(String? id, String? questionId) {
    return FirebaseFirestore.instance
        .collection('categories')
        .doc(id)
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .orderBy('order', descending: false)
        .snapshots();
  }

  @override
  List<AnswerModel> fetchAnswers(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot doc) {
      return AnswerModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> setQuestion(CategoryModel category, String? id, Map data,
      int? totalQuestions, bool? newQuestion) async {
    if (newQuestion!) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(category.id)
          .collection("questions")
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {});

//update the amount of questions inside a category
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(category.id)
          .update({"questionCount": totalQuestions}).catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(category.id)
          .collection("questions")
          .doc(id)
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    }
  }

  @override
  Future<void> removeQuestion(
      CategoryModel? category, String? questionId, int? totalQuestions) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(category!.id)
        .collection('questions')
        .doc(questionId)
        .delete()
        .catchError((e) {
      //    print(e);
    });

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(category.id)
        .update({"questionCount": totalQuestions! - 1}).catchError((e) {});
  }

  @override
  Future<void> setAnswer(String? surveyId, String? questionId, String? answerId,
      Map data, bool insertNewAnswer) async {
    if (insertNewAnswer) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(surveyId)
          .collection("questions")
          .doc(questionId)
          .collection('answers')
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(surveyId)
          .collection("questions")
          .doc(questionId)
          .collection('answers')
          .doc(answerId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {
        //   print(e);
      });
    }
  }

  @override
  Future<void> removeAnswerFromQuestion(
      String? category, String? questionId, String? answerId) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(category)
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId)
        .delete()
        .catchError((e) {
      //    print(e);
    });
  }

  @override
  Future<void> setUserSurveyAnswers(
    String surveyTitle,
    AppUser user,
    String? category,
    int? index,
    Map surveyData,
    Map data,
    String? id,
  ) async {
    //adding data to correct survey
    await FirebaseFirestore.instance
        .collection("results")
        .where("title", isEqualTo: surveyTitle)
        .get()
        .then((value) async {
      //first time uploading survey
      if (category == "Bewegen" || id == "") {
        // List<int> firstInt = [];
        // var dateTime = DateTime.now();
        // Map<String, dynamic> firstData = {
        //   "email": user.email,
        //   "index": index,
        //   "categories": surveyData['categories'],
        //   "category_points": firstInt,
        //   "total_points": 0,
        //   "total_duration": 0,
        //   "finished": false,
        //   "date": dateTime,
        // };

        // print(surveyData['date']);

        await FirebaseFirestore.instance
            .collection("results")
            .doc(value.docs.first.id)
            .collection('scores')
            .doc()
            .set(surveyData as Map<String, dynamic>);

        await FirebaseFirestore.instance
            .collection("results")
            .doc(value.docs.first.id)
            .collection('scores')
            .where("date", isEqualTo: surveyData['date'])
            .get()
            .then((value2) async {
          await FirebaseFirestore.instance
              .collection("results")
              .doc(value.docs.first.id)
              .collection('scores')
              .doc(value2.docs.first.id)
              .collection(category!)
              .doc()
              .set(data as Map<String, dynamic>);

//update data
          // await FirebaseFirestore.instance
          //     .collection("results")
          //     .doc(value.docs.first.id)
          //     .collection('scores')
          //     .doc(value2.docs.first.id)
          //     .update(surveyData);
        });
      }
      //second time uploading survey
      else {
        await FirebaseFirestore.instance
            .collection("results")
            .doc(value.docs.first.id)
            .collection('scores')
            .doc(id)
            .collection(category!)
            .doc()
            .set(data as Map<String, dynamic>);
        //   .get()
        //   .then((value2) async {
        // await FirebaseFirestore.instance
        //     .collection("results")
        //     .doc(value.docs.first.id)
        //     .collection('scores')
        //     .doc(value2.docs.first.id)
        //     .collection(category)
        //     .doc()
        //     .set(data);

//update data
        await FirebaseFirestore.instance
            .collection("results")
            .doc(value.docs.first.id)
            .collection('scores')
            .doc(id)
            .update(surveyData as Map<String, dynamic>);
      }
    });
  }

  @override
  Future<List<SurveyResultModel>> checkSurveyResult(
    String surveyTitle,
    String? email,
  ) async {
    List<SurveyResultModel> result = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("results")
        .where("title", isEqualTo: surveyTitle)
        .get()
        .then((value) {
      return FirebaseFirestore.instance
          .collection("results")
          .doc(value.docs.first.id)
          .collection("scores")
          .where("email", isEqualTo: email)
          .get();
    });

    // ignore: unnecessary_null_comparison
    if (snapshot == null) {
      return result;
    } else {
      snapshot.docs.map((DocumentSnapshot doc) {
        return result.add(SurveyResultModel.fromSnapshot(doc));
      }).toList();

      result.sort((a, b) => b.date!.compareTo(a.date!));

      return result;
    }
  }

  @override
  Future<void> setSurveyToFalse(
      String surveyTitle, AppUser user, SurveyResultModel surveyResult) async {
    await FirebaseFirestore.instance
        .collection("results")
        .where("title", isEqualTo: surveyTitle)
        .get()
        .then((value) {
      return FirebaseFirestore.instance
          .collection("results")
          .doc(value.docs.first.id)
          .collection("scores")
          .doc(surveyResult.id)
          .update({"finished": true});
    });
  }

  @override
  Future<String?> createDTDid() async {
    var uuid = Uuid();

    final String id = uuid.v1();
    String? docId;

    Map<String, dynamic> firstData = {
      "id": id,
      "date": DateTime.now(),
    };

    await FirebaseFirestore.instance
        .collection("results")
        .doc("hddx5cnwvjLeSqQK5vDQ")
        .collection("scores")
        .doc()
        .set(firstData);

    await FirebaseFirestore.instance
        .collection("results")
        .doc("hddx5cnwvjLeSqQK5vDQ")
        .collection("scores")
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      docId = value.docs.first.id.toString();
    });

    return docId;
  }

  @override
  Future<void> setDTDSurveyResults(String? id, Map data) async {
    await FirebaseFirestore.instance
        .collection("results")
        .doc("hddx5cnwvjLeSqQK5vDQ")
        .collection("scores")
        .doc(id)
        .collection("DTD")
        .doc()
        .set(data as Map<String, dynamic>);
  }
}
