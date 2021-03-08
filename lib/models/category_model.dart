import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  CategoryModel({this.id, this.questionCount, this.category})
      : reference = null;

  final String? id;
  final int? questionCount;
  final String? category;

  final DocumentReference? reference;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        questionCount = snapshot.data()!['questionCount'],
        category = snapshot.data()!['category'],
        reference = snapshot.reference;
}
