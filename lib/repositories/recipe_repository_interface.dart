import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

abstract class IRecipeRepository {
  Future<List<RecipeModel>> getRecipeListOnce();

  Stream<QuerySnapshot> streamAllRecipes();

  List<RecipeModel> getRecipeList(QuerySnapshot snapshot);

  Future<void> updateRecipe(String recipeId, Map data, bool newItem);

  Future<void> removeRecipe(String recipeId);
}
