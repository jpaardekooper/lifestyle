import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/repositories/food_preparation_repository.dart';
import 'package:lifestylescreening/repositories/food_preparation_repository_interface.dart';

class FoodPreparationController {
  final IFoodPreparationRepository _foodPreparationRepository =
      FoodPreparationRepository();

  //stream ingredients data
  Stream<QuerySnapshot> streamIngredients(String recipeId) {
    return _foodPreparationRepository.streamIngredients(recipeId);
  }

//fetching IngredientsModel data to a list
  List<IngredientsModel> fetchIngredients(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return _foodPreparationRepository.fetchIngredients(snapshot);
  }

//stream method data
  Stream<QuerySnapshot> streamMethod(String recipeId) {
    return _foodPreparationRepository.streamMethod(recipeId);
  }

//fetching MethodModel data to a list
  List<MethodModel> fetchMethod(AsyncSnapshot<QuerySnapshot> snapshot) {
    return _foodPreparationRepository.fetchMethod(snapshot);
  }

//stream nutritional data
  Stream<QuerySnapshot> streamNutritionalValue(String recipeId) {
    return _foodPreparationRepository.streamNutritionalValue(recipeId);
  }

//fetching NutritionalValueModel data to a list
  List<NutritionalValueModel> fetchNutritionalValue(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return _foodPreparationRepository.fetchNutritionalValue(snapshot);
  }

  //update or add new data for ingredient
  Future<void> updateIngredient(
      String recipeId, String ingredientId, Map data, bool newIngredient) {
    return _foodPreparationRepository.updateIngredient(
        recipeId, ingredientId, data, newIngredient);
  }

  //update or add new data for method
  Future<void> updateMethod(
      String recipeId, String methodId, Map data, bool newMethod) {
    return _foodPreparationRepository.updateMethod(
        recipeId, methodId, data, newMethod);
  }

  //update or add new data for nutritional
  Future<void> updateNutritrionalValue(String recipeId,
      String nutritrionalValueId, Map data, bool newNutritional) {
    return _foodPreparationRepository.updateNutritionalValue(
        recipeId, nutritrionalValueId, data, newNutritional);
  }

  //remove data

  Future<void> removeIngredient(String recipeId, String ingredientId) {
    return _foodPreparationRepository.deleteIngredient(recipeId, ingredientId);
  }

  Future<void> removeMethod(String recipeId, String methodId) {
    return _foodPreparationRepository.deleteMethod(recipeId, methodId);
  }

  Future<void> removeNutritionalValue(String recipeId, String nutritionalID) {
    return _foodPreparationRepository.deleteNutritrionalValue(
        recipeId, nutritionalID);
  }
}
