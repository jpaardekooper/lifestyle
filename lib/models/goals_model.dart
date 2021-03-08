import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsModel {
  GoalsModel({this.id, this.goals, this.category}) : reference = null;

  final String? id;
  final String? goals;
  final String? category;

  final DocumentReference? reference;

  GoalsModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        goals = snapshot.data()!['goal'] ?? "",
        category = snapshot.data()!['category'] ?? "",
        reference = snapshot.reference;
}
