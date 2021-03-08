import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/repositories/category_repository.dart';
import 'package:lifestylescreening/repositories/category_repository_interface.dart';

class CategoryController {
  final ICategoryRepository _categoryRepository = CategoryRepository();

  Stream<QuerySnapshot> streamCategories() {
    return _categoryRepository.streamCategories();
  }

  List<CategoryModel> fetchCategories(QuerySnapshot snapshot) {
    return _categoryRepository.fetchCategories(snapshot);
  }

  Future<void> updateCategory(String? id, Map data, bool? newItem) {
    return _categoryRepository.updateCategory(id, data, newItem);
  }

  Future<void> removeCategory(String? id) {
    return _categoryRepository.removeCategory(id);
  }
}
