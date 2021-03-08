import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/repositories/recipe_repository.dart';
import 'package:lifestylescreening/repositories/recipe_repository_interface.dart';

class RecipeController {
  final IRecipeRepository _recipeRepository = RecipeRepository();

  Stream<QuerySnapshot> streamRecipes() {
    return _recipeRepository.streamAllRecipes();
  }

  List<RecipeModel> getRecipeList(QuerySnapshot snapshot) {
    return _recipeRepository.getRecipeList(snapshot);
  }

  Future<List<RecipeModel>> getUserRecipes(String? userId) {
    return _recipeRepository.getUserRecipes(userId);
  }

  Future<void> updateUserRecipe(String? recipeId, Map data, bool newItem) {
    return _recipeRepository.updateUserRecipe(recipeId, data, newItem);
  }

  Future<void> updateRecipe(String? recipeId, Map data, bool newItem) {
    return _recipeRepository.updateRecipe(recipeId, data, newItem);
  }

  Future<void> removeRecipe(String? recipeId, String? url) {
    return _recipeRepository.removeRecipe(recipeId, url);
  }

  Future<void> removeUserRecipe(String? recipeId, String? url){
    return _recipeRepository.removeUserRecipe(recipeId, url);
  }

  Future<List<RecipeModel>> getRecipeListOnce() {
    return _recipeRepository.getRecipeListOnce();
  }

  Future<List<RecipeModel>> getUserFavoriteRecipe(String? userId) {
    return _recipeRepository.getUserFavoriteRecipe(userId);
  }

  Future<bool> checkFavoriteRecipe(String? markerId, String? userId) {
    return _recipeRepository.checkFavoriteRecipe(markerId, userId);
  }

  Future<void> addFavoriteRecipe(String? userId, String? recipeId) {
    return _recipeRepository.addFavoriteRecipe(userId, recipeId);
  }

  Future<void> removeFavoriteRecipe(String? userId, String? recipeId) {
    return _recipeRepository.removeFavoriteRecipe(userId, recipeId);
  }

  Future<void> uploadImage(File? img) {
    return _recipeRepository.uploadImage(img);
  }

  Future<String> getImage(String? image) {
    return _recipeRepository.getImage(image);
  }
}
