import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardIngredients extends StatelessWidget {
  CardIngredients(this.id);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("recipes")
            .doc(id)
            .collection("ingredients")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot));
        },
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
}
