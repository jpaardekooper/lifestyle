import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addUserData(userData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      //   print(e);
    });
  }

  Future<void> updateQuizData(
      Map quizData, String quizId, String userName) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userName)
        .collection("MyQuiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      // print(e.toString());
    });
  }

  Future<void> addQuestionData(
      Map questionData, String quizId, String userName) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userName)
        .collection("MyQuiz")
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      //    print(e);
    });
  }

  Future<void> sendMessageData(
      String email, Map chatMessage, String category) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(email + "_" + category)
        .collection("user_message")
        .doc()
        .set(chatMessage)
        .catchError((e) {
      //    print(e);
    });

    await FirebaseFirestore.instance
        .collection("messages")
        .doc(email + "_" + category)
        .set({
      'open': true,
      'category': category,
    }).catchError((e) {});
  }

  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(id)
        .collection("user_message")
        .doc()
        .set(chatMessage)
        .catchError((e) {
      //    print(e);
    });
  }

  getUserInfo(String email) async {
    String userName;

    await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        try {
          userName = result.data()["userName"];
          // ignore: unused_catch_clause
        } on Exception catch (e) {
          //
        }
        //  print(userName);
        return userName;
      });
    });

    // var docRef = FirebaseFirestore.instance
    //     .collection("users")
    //     .where("email", isEqualTo: email)
    //     .get()
    //     .then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((f) => print('${f.data}}'));
    // });

    // FirebaseFirestore.instance
    //       .collection("users")
    //       .where("email", isEqualTo: email)
    //       .get();
    //   print(test);
    // }
  }

  removeQuiz(String quizId, String userName) {
    FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userName)
        .collection("MyQuiz")
        .doc(quizId)
        .delete();
  }

  getQuizezData(String username) async {
    // print("getting quiz data for $username");
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc("jasper")
        .collection("MyQuiz")
        .snapshots();
  }

  getQuizData(String quizId, String username) async {
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc("jasper")
        .collection("MyQuiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
