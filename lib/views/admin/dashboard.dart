import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/views/admin/chat_tab_admin.dart';
import 'package:lifestylescreening/views/startup.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    return SafeArea(
        child: Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("DASHBOARD"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  //  await auth.signOut();
                  await HelperFunctions.saveUserLoggedInSharedPreference(false);
                  await HelperFunctions.removeUserNameSharedPreference();
                  await HelperFunctions.removeUserEmailSharedPreference();
                  await HelperFunctions.removeUserPasswordSharedPreference();

                  await Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => StartUp()));
                },
                child: Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("messages")
              .orderBy('category', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text("There is no expense");
            return FadeInTransition(
                child: ListView(children: getExpenseItems(snapshot)));
          }),
    ));
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => MessageOverView(
            category: doc['category'],
            email: userEmail,
            sender: false,
            id: doc.id))
        .toList();
  }
}

class MessageOverView extends StatelessWidget {
  MessageOverView({this.category, this.email, this.sender, this.id});
  final String category;
  final String email;
  final bool sender;
  final String id;

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatTabAdmin(email: email, sender: sender, id: id),
            ),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.question_answer,
            color: Colors.white,
          ),
          title: Text(id),
          subtitle: Text(category),
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
