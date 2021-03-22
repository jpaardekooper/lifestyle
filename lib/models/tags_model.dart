import 'package:cloud_firestore/cloud_firestore.dart';

class TagsModel {
  TagsModel({
    this.id,
    this.tag,
  }) : reference = null;

  final String? id;
  final String? tag;

  final DocumentReference? reference;

  TagsModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        tag = snapshot.data()!['tag'],
        reference = snapshot.reference;
}
