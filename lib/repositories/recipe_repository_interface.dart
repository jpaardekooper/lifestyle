import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

abstract class IRecipeRepository {
  Future<List<RecipeModel>> getRecipeListOnce();

  Stream<QuerySnapshot> streamAllRecipes();

  Future<List<RecipeModel>> getUserRecipes(String userId);

  List<RecipeModel> getRecipeList(QuerySnapshot snapshot);

  Future<void> updateUserRecipe(String recipeId, Map data, bool newItem);

  Future<void> updateRecipe(String recipeId, Map data, bool newItem);

  Future<void> removeRecipe(String recipeId, String url);

  Future<void> removeUserRecipe(String recipeId, String url);

  Future<List<RecipeModel>> getUserFavoriteRecipe(String userId);

  Future<void> addFavoriteRecipe(String userId, String recipeId);

  Future<void> removeFavoriteRecipe(String userId, String recipeId);

  Future<bool> checkFavoriteRecipe(String markerId, String userId);

  Future<void> uploadImage(File img);

  Future<String> getImage(String image);
}
