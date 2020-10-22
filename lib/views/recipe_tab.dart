import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/recipe/recipe_container.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Recepten",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("recipes").snapshots(),
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
        .map((doc) => RecipeStyle(
              name: doc['title'],
              id: doc.id,
              url: doc['url'],
            ))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
