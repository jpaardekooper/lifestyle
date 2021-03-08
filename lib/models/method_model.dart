import 'package:cloud_firestore/cloud_firestore.dart';

class MethodModel {
  MethodModel({this.id, this.step, this.instruction}) : reference = null;

  final String? id;
  final int? step;
  final String? instruction;

  final DocumentReference? reference;

  MethodModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        step = snapshot.data()!['step'],
        instruction = snapshot.data()!['instruction'],
        reference = snapshot.reference;
}
