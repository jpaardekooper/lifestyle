import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/category_model.dart';

abstract class ICategoryRepository {
  Stream<QuerySnapshot> streamCategories();

  List<CategoryModel> fetchCategories(QuerySnapshot snapshot);

  Future<void> updateCategory(String id, Map data, bool newItem);

  Future<void> removeCategory(String id);
}
