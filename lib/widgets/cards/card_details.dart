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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.name),
            ),
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
                Expanded(
                  child: Column(
                    children: [
                      Text("ingriedenten"),
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
                      Text("Methode"),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("recipes")
                            .doc(widget.id)
                            .collection("method")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Text("There is no expense");
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
                          if (!snapshot.hasData)
                            return Text("There is no expense");
                          return Column(
                              children: getNutritionalValue(snapshot));
                        },
                      ),
                      SizedBox(
                        height: 500,
                      )
                    ],
                  ),
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
          (doc) => ListTile(
              title: Text(
                  doc['amount'].toString() + doc['unit'] + " " + doc['name'])),
        )
        .toList();
  }
}
