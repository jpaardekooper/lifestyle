import 'package:cloud_firestore/cloud_firestore.dart';

class InterestModel {
  InterestModel({this.id, this.interest, this.tag}) : reference = null;

  final String? id;
  final String? interest;
  final String? tag;

  final DocumentReference? reference;

  InterestModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        interest = snapshot.data()!['interest'] ?? "",
        tag = snapshot.data()!['tag'] ?? "",
        reference = snapshot.reference;
}
