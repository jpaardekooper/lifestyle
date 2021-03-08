import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser(
      {this.id,
      this.email,
      this.userName,
      this.role,
      this.gender,
      this.age,
      this.height,
      this.weight,
      this.favorite_recipes})
      : reference = null;

  final String? id;
  final String? email;
  final String? role;
  final String? userName;
  final String? gender;
  final int? age;
  final int? height;
  final int? weight;
  final List<String>? favorite_recipes;

  final DocumentReference? reference;

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        email = snapshot.data()!['email'] ?? "",
        role = snapshot.data()!['role'] ?? "user",
        userName = snapshot.data()!['userName'] ?? "",
        gender = snapshot.data()!['gender'] ?? "",
        age = snapshot.data()!['age'] ?? 0,
        height = snapshot.data()!['height'] ?? 0,
        weight = snapshot.data()!['weight'] ?? 0,
        favorite_recipes =
            List.from(snapshot.data()!['favorite_recipes'] ?? []),
        reference = snapshot.reference;
}
