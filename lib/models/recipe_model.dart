import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  RecipeModel(
      {this.id,
      this.title,
      this.url,
      this.difficulty,
      this.duration,
      this.review,
      this.published,
      this.date,
      this.tags})
      : reference = null;

  final String? id;
  final String? title;
  final String? url;
  final String? difficulty;
  final int? duration;
  final int? review;
  final bool? published;
  final Timestamp? date;
  final List<String>? tags;

  final DocumentReference? reference;

  RecipeModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        title = snapshot.data()!['title'],
        url = snapshot.data()!['url'] ?? "",
        difficulty = snapshot.data()!['difficulty'],
        duration = snapshot.data()!['duration'],
        review = snapshot.data()!['review'],
        published = snapshot.data()!['published'],
        date = snapshot.data()!['date'],
        tags = List.from(snapshot.data()!['tags']),
        reference = snapshot.reference;
}
