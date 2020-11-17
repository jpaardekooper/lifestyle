import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/chat_tab.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/extra_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/h3_green_blue_text.dart';
import 'package:lifestylescreening/widgets/text/h3_grey_text.dart';
import 'package:lifestylescreening/widgets/text/h3_orange_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/intro_light_grey_text.dart';

import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class PageFour extends StatefulWidget {
  PageFour({Key key}) : super(key: key);

  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1Text(text: "Lorem ipsum dolar sit amet"),
          H2Text(text: "Lorem ipsum dolar sit amet"),
          H3GreyText(text: "Lorem ipsum dolar sit amet"),
          H3OrangeText(text: "Lorem ipsum dolar sit amet"),
          H3GreenBlueText(text: "Lorem ipsum dolar sit amet"),
          IntroLightGreyText(text: "Lorem ipsum dolar sit amet"),
          IntroGreyText(text: "Lorem ipsum dolar sit amet"),
          ExtraText(text: "Lorem ipsum dolar sit amet"),
          BodyText(text: "Lorem ipsum dolar sit amet"),
        ],
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot, String email) {
    return snapshot.data.docs
        .map((doc) => CategoryOptions(
              category: doc['category'],
              email: email,
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
