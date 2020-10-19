import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/views/chat_tab.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class SelectQuestionTab extends StatefulWidget {
  SelectQuestionTab({Key key}) : super(key: key);

  @override
  _SelectQuestionTabState createState() => _SelectQuestionTabState();
}

class _SelectQuestionTabState extends State<SelectQuestionTab> {
  String userEmail;

  @override
  void initState() {
    getMyEmail();
    super.initState();
  }

  getMyEmail() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        userEmail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stel gerust een vraag"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("categories")
              .orderBy('order', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text("There is no expense");
            return FadeInTransition(
                child: ListView(children: getExpenseItems(snapshot)));
          }),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => CategoryOptions(
              category: doc['category'],
              email: userEmail,
              sender: true,
            ))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CategoryOptions extends StatelessWidget {
  CategoryOptions({this.category, this.email, this.sender});
  final String category;
  final String email;
  final bool sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xff007EF4),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatTab(email: email, category: category, sender: sender),
            ),
          ),
        },
        child: ListTile(
          leading: Icon(
            Icons.question_answer,
            color: Colors.white,
          ),
          title: Text(category),
          trailing: Material(
            color: Color(0xff007EF4),
            child: SizedBox(
              height: 45,
              width: 45,
              child: InkWell(
                customBorder: CircleBorder(),
                highlightColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
