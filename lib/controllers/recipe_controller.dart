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

  Future<void> updateRecipe(String recipeId, Map data, bool newItem) {
    return _recipeRepository.updateRecipe(recipeId, data, newItem);
  }

  Future<void> removeRecipe(String recipeId) {
    return _recipeRepository.removeRecipe(recipeId);
  }

  Future<List<RecipeModel>> getRecipeListOnce() {
    return _recipeRepository.getRecipeListOnce();
  }

  Future<List<RecipeModel>> getUserFavoriteRecipe(String userId) {
    return _recipeRepository.getUserFavoriteRecipe(userId);
  }

  Future<bool> checkFavoriteMarker(String markerId, String userId) {
    return _recipeRepository.checkFavoriteMarker(markerId, userId);
  }

  Future<void> addFavoriteRecipe(String userId, String recipeId) {
    return _recipeRepository.addFavoriteRecipe(userId, recipeId);
  }

  Future<void> removeFavoriteRecipe(String userId, String recipeId) {
    return _recipeRepository.removeFavoriteRecipe(userId, recipeId);
  }
}
