import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';

abstract class IFoodPreparationRepository {
  //stream ingredients data
  Stream<QuerySnapshot> streamIngredients(String recipeId);

//fetching IngredientsModel data to a list
  List<IngredientsModel> fetchIngredients(
      AsyncSnapshot<QuerySnapshot> snapshot);

//stream method data
  Stream<QuerySnapshot> streamMethod(String recipeId);

//fetching MethodModel data to a list
  List<MethodModel> fetchMethod(AsyncSnapshot<QuerySnapshot> snapshot);

//stream nutritional data
  Stream<QuerySnapshot> streamNutritionalValue(String recipeId);

//fetching NutritionalValueModel data to a list
  List<NutritionalValueModel> fetchNutritionalValue(
      AsyncSnapshot<QuerySnapshot> snapshot);

  //add, update, insert
  Future<void> updateIngredient(
      String recipeId, String ingredientId, Map data, bool newIngriendient);

  Future<void> updateMethod(
      String recipeId, String methodId, Map data, bool newMethod);

  Future<void> updateNutritionalValue(
      String recipeId, String nutritionalId, Map data, bool newNutritional);

  //delete
  Future<void> deleteIngredient(String recipeId, String ingredientId);
  //delete
  Future<void> deleteMethod(String recipeId, String methodId);
  //delete
  Future<void> deleteNutritrionalValue(String recipeId, String nutritionalId);
}
