import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  RecipeModel(
      {this.id,
      this.title,
      this.url,
      this.difficulty,
      this.duration,
      this.review,
      this.published})
      : reference = null;

  final String id;
  final String title;
  final String url;
  final String difficulty;
  final int duration;
  final int review;
  final bool published;

  final DocumentReference reference;

  RecipeModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        title = snapshot.data()['title'],
        url = snapshot.data()['url'],
        difficulty = snapshot.data()['difficulty'],
        duration = snapshot.data()['duration'],
        review = snapshot.data()['review'],
        published = snapshot.data()['published'],
        reference = snapshot.reference;
}
