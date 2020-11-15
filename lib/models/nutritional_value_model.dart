import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionalValueModel {
  NutritionalValueModel({this.id, this.amount, this.unit, this.name})
      : reference = null;

  final String id;
  final String amount;
  final String unit;
  final String name;

  final DocumentReference reference;

  NutritionalValueModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        amount = snapshot.data()['amount'],
        unit = snapshot.data()['unit'],
        name = snapshot.data()['name'],
        reference = snapshot.reference;
}
