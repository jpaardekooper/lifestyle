import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

abstract class IRecipeRepository {
  Future<List<RecipeModel>> getRecipeListOnce();

  Stream<QuerySnapshot> streamAllRecipes();

  List<RecipeModel> getRecipeList(QuerySnapshot snapshot);

  Future<void> updateRecipe(String recipeId, Map data, bool newItem);

  Future<void> removeRecipe(String recipeId);

  Future<List<RecipeModel>> getUserFavoriteRecipe(String userId);

  Future<void> addFavoriteRecipe(String userId, String recipeId);

  Future<void> removeFavoriteRecipe(String userId, String recipeId);

  Future<bool> checkFavoriteMarker(String markerId, String userId);
}
