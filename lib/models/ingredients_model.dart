import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientsModel {
  IngredientsModel({this.id, this.amount, this.unit, this.product})
      : reference = null;

  final String? id;
  final String? amount;
  final String? unit;
  final String? product;

  final DocumentReference? reference;

  IngredientsModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        amount = snapshot.data()!['amount'] ?? "",
        unit = snapshot.data()!['unit'] ?? "",
        product = snapshot.data()!['product'] ?? "",
        reference = snapshot.reference;
}
