import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/repositories/category_repository_interface.dart';

class CategoryRepository extends ICategoryRepository {
  @override
  Stream<QuerySnapshot> streamCategories() {
    return FirebaseFirestore.instance.collection("categories").snapshots();
  }

  @override
  List<CategoryModel> fetchCategories(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return CategoryModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> updateCategory(String? id, Map data, bool? newItem) async {
    if (newItem!) {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(id)
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    }
  }

  @override
  Future<void> removeCategory(String? id) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(id)
        .delete()
        .catchError((e) {});
  }
}
