import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionalValueModel {
  NutritionalValueModel({this.id, this.amount, this.unit, this.name})
      : reference = null;

  final String? id;
  final double? amount;
  final String? unit;
  final String? name;

  final DocumentReference? reference;

  NutritionalValueModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        amount = (snapshot.data()!['amount']).toDouble(),
        unit = snapshot.data()!['unit'],
        name = snapshot.data()!['name'],
        reference = snapshot.reference;
}
