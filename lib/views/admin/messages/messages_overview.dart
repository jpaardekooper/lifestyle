import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/admin/messages/message_admin.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class MessageOverView extends StatelessWidget {
  const MessageOverView({this.userEmail});
  final userEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .orderBy('category', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("There is no expense");
        return FadeInTransition(
            child: ListView(children: getExpenseItems(snapshot)));
      },
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => MessageCard(
            category: doc['category'],
            email: userEmail,
            sender: false,
            id: doc.id))
        .toList();
  }
}

class MessageCard extends StatelessWidget {
  MessageCard({this.category, this.email, this.sender, this.id});
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
                  MessageAdmin(email: email, sender: sender, id: id),
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
