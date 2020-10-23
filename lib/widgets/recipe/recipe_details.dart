import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/recipe/custom_sliverscroll.dart';
import 'package:lifestylescreening/widgets/recipe/ingredients_value.dart';
import 'package:lifestylescreening/widgets/text/dark_text.dart';
import 'package:lifestylescreening/widgets/text/grey_text.dart';

class CardDetails extends StatefulWidget {
  CardDetails({this.name, this.id, this.url});
  final String name;
  final String id;
  final String url;

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  void onTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: 250,
                  imgUrl: widget.url,
                  name: widget.name,
                  onTap: onTap),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: 70, left: 50, right: 50, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GreyText(
                            text:
                                // ignore: lines_longer_than_80_chars
                                "Vergroot uw aantal groenten en ontvang drie van uw vijf-per-dag met deze geurige vetarme vegatarische curry",
                            size: 15),
                        Divider(),
                        DarkText(text: "Ingrediënten", size: 18),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("recipes")
                              .doc(widget.id)
                              .collection("ingredients")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Text("There is no expense");
                            return Column(children: getExpenseItems(snapshot));
                          },
                        ),
                        Divider(),
                        DarkText(text: "Methode", size: 16),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("recipes")
                              .doc(widget.id)
                              .collection("method")
                              .orderBy("step", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Text("There is no expense");
                            return Column(children: getMethodItems(snapshot));
                          },
                        ),
                        Divider(),
                        DarkText(text: "Voedingswaarde per portie", size: 16),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("recipes")
                              .doc(widget.id)
                              .collection("nutritionalValue")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Text("There is no expense");
                            return Column(
                                children: getNutritionalValue(snapshot));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                      size: 18,
                    ),
                    Text(
                      "Favoriete",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.rate_review,
                      color: Colors.black,
                      size: 18,
                    ),
                    Text(
                      "Review",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => Ingredients(
              amount: doc['amount'].toString(),
              unit: doc['unit'],
              product: doc['product'],
            ))
        .toList();
  }

  getMethodItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => Method(
              step: doc['step'].toString(),
              instruction: doc['instruction'],
            ))
        .toList();
  }

  getNutritionalValue(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => NutritionalValue(
            amount: doc['amount'].toString(),
            name: doc['name'],
            unit: doc['unit']))
        .toList();
  }
}
