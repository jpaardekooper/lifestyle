import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

abstract class IRecipeRepository {
  Future<List<RecipeModel>> getRecipeListOnce();

  Future<List<RecipeModel>> getSubmittedRecipeListOnce();

  Stream<QuerySnapshot> streamAllRecipes();

  Stream<QuerySnapshot> streamUserRecipes(String? userId);

  List<RecipeModel> getUserRecipeList(QuerySnapshot snapshot);

  List<RecipeModel> getRecipeList(QuerySnapshot snapshot);

  Future<void> updateUserRecipe(
      String? recipeId, Map data, bool newItem);

  Future<void> updateRecipe(
      String? recipeId, Map data, bool newItem);

  Future<void> removeRecipe(String? recipeId, String? url);

  Future<void> removeUserRecipe(String? recipeId, String? url);

  Future<List<RecipeModel>> getUserFavoriteRecipe(String? userId);

  Future<void> addFavoriteRecipe(String? userId, String? recipeId);

  Future<void> removeFavoriteRecipe(String? userId, String? recipeId);

  Future<bool> checkFavoriteRecipe(String? markerId, String? userId);

  Future<void> uploadImage(File? img, String? oldImg);

  Future<String> getImage(String? image);
}
