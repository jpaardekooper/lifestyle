import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatefulWidget {
  CardDetails({this.name, this.id});
  final String name;
  final String id;

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("recipes")
                  .doc(widget.id)
                  .collection("ingredients")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return ListView(children: getExpenseItems(snapshot));
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("recipes")
                  .doc(widget.id)
                  .collection("method")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return ListView(children: getMethodItems(snapshot));
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("recipes")
                  .doc(widget.id)
                  .collection("nutritionalValue")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("There is no expense");
                return ListView(children: getNutritionalValue(snapshot));
              },
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
              title: Text(doc['instruction'] + " " + doc['step'].toString())),
        )
        .toList();
  }

  getNutritionalValue(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map(
          (doc) => ListTile(
              title: Text(doc['amount'].toString() +
                  doc['name'].toString() +
                  doc['unit'].toString())),
        )
        .toList();
  }
}
