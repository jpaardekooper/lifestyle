import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/cards/nutritional_value.dart';

class CardDetails extends StatefulWidget {
  CardDetails({this.name, this.id, this.url});
  final String name;
  final String id;
  final String url;

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            title: Container(
              padding: EdgeInsets.all(12),
              child: Text(widget.name),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: 200.0,
            flexibleSpace: Hero(
                tag: "url",
                child: Image.network(
                  widget.url,
                  fit: BoxFit.fitWidth,
                )),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_circle),
                tooltip: 'Add new entry',
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Text("ingriedenten"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("recipes")
                      .doc(widget.id)
                      .collection("ingredients")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Text("There is no expense");
                    return Column(children: getExpenseItems(snapshot));
                  },
                ),
                Text("Methode"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("recipes")
                      .doc(widget.id)
                      .collection("method")
                      .orderBy("step", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Text("There is no expense");
                    return Column(children: getMethodItems(snapshot));
                  },
                ),
                Text("Nutrio"),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("recipes")
                      .doc(widget.id)
                      .collection("nutritionalValue")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Text("There is no expense");
                    return Column(children: getNutritionalValue(snapshot));
                  },
                ),
                SizedBox(
                  height: 500,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map(
          (doc) => ListTile(
              leading: Icon(Icons.data_usage),
              title: Text(doc['amount'].toString() +
                  doc['unit'] +
                  " " +
                  doc['product'])),
        )
        .toList();
  }

  getMethodItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map(
          (doc) => ListTile(
              title: Text("Stap" + doc['step'].toString()),
              subtitle: Text(doc['instruction'])),
        )
        .toList();
  }

  getNutritionalValue(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map(
          (doc) => NutritionalValue(
              amount: doc['amount'].toString(),
              name: doc['name'],
              unit: doc['unit']),
        )
        .toList();
  }
}
