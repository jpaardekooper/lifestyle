import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';

abstract class IFoodPreparationRepository {
  //stream ingredients data
  Stream<QuerySnapshot> streamIngredients(String? recipeId, String? collection);

//fetching IngredientsModel data to a list
  List<IngredientsModel> fetchIngredients(
      AsyncSnapshot<QuerySnapshot> snapshot);

//stream method data
  Stream<QuerySnapshot> streamMethod(String? recipeId, String? collection);

//fetching MethodModel data to a list
  List<MethodModel> fetchMethod(AsyncSnapshot<QuerySnapshot> snapshot);

//stream nutritional data
  Stream<QuerySnapshot> streamNutritionalValue(
      String? recipeId, String? collection);

//fetching NutritionalValueModel data to a list
  List<NutritionalValueModel> fetchNutritionalValue(
      AsyncSnapshot<QuerySnapshot> snapshot);

  //add, update, insert
  Future<void> updateIngredient(String? recipeId, String? ingredientId,
      Map data, bool? newIngriendient, String? collection);

  Future<void> updateMethod(String? recipeId, String? methodId, Map data,
      bool? newMethod, String? collection);

  Future<void> updateNutritionalValue(String? recipeId, String? nutritionalId,
      Map data, bool? newNutritional, String? collection);

  //delete
  Future<void> deleteIngredient(
      String? recipeId, String? ingredientId, String? collection);
  //delete
  Future<void> deleteMethod(
      String? recipeId, String? methodId, String? collection);
  //delete
  Future<void> deleteNutritionalValue(
      String? recipeId, String? nutritionalId, String? collection);
      
  Future<void> transferRecipe(String? recipeId);
}
