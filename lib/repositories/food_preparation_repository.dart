import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/repositories/food_preparation_repository_interface.dart';

class FoodPreparationRepository extends IFoodPreparationRepository {
  @override
  List<IngredientsModel> fetchIngredients(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot doc) {
      return IngredientsModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<MethodModel> fetchMethod(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot doc) {
      return MethodModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<NutritionalValueModel> fetchNutritionalValue(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot doc) {
      return NutritionalValueModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamIngredients(
      String? recipeId, String? collection) {
    return FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection("ingredients")
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamMethod(String? recipeId, String? collection) {
    return FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection("method")
        .orderBy('step', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamNutritionalValue(
      String? recipeId, String? collection) {
    return FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection("nutritionalValue")
        .snapshots();
  }

  @override
  Future<void> updateIngredient(String? recipeId, String? ingredientId,
      Map data, bool? newIngriendient, String? collection) async {
    if (newIngriendient!) {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('ingredients')
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('ingredients')
          .doc(ingredientId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    }
  }

  @override
  Future<void> updateMethod(String? recipeId, String? methodId, Map data,
      bool? newMethod, String? collection) async {
    if (newMethod!) {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('method')
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('method')
          .doc(methodId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    }
  }

  @override
  Future<void> updateNutritionalValue(String? recipeId, String? nutritionalId,
      Map data, bool? newNutritional, String? collection) async {
    if (newNutritional!) {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('nutritionalValue')
          .doc()
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection(collection!)
          .doc(recipeId)
          .collection('nutritionalValue')
          .doc(nutritionalId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {});
    }
  }

  @override
  Future<void> deleteIngredient(
      String? recipeId, String? ingredientId, String? collection) async {
    await FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection('ingredients')
        .doc(ingredientId)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> deleteMethod(
      String? recipeId, String? methodId, String? collection) async {
    await FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection('method')
        .doc(methodId)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> deleteNutritionalValue(
      String? recipeId, String? nutritionalId, String? collection) async {
    await FirebaseFirestore.instance
        .collection(collection!)
        .doc(recipeId)
        .collection('nutritionalValue')
        .doc(nutritionalId)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> transferRecipe(String? recipeId) async {
    var snapshotIngredients = await FirebaseFirestore.instance
        .collection('createdRecipes')
        .doc(recipeId)
        .collection('ingredients')
        .get();

    var snapshotMethods = await FirebaseFirestore.instance
        .collection('createdRecipes')
        .doc(recipeId)
        .collection('method')
        .get();

    var snapshotNutritrional = await FirebaseFirestore.instance
        .collection('createdRecipes')
        .doc(recipeId)
        .collection('nutritionalValue')
        .get();

    List<IngredientsModel> ingredientsTransfer =
        snapshotIngredients.docs.map((DocumentSnapshot doc) {
      return IngredientsModel.fromSnapshot(doc);
    }).toList();

    List<MethodModel> methodsTransfer =
        snapshotMethods.docs.map((DocumentSnapshot doc) {
      return MethodModel.fromSnapshot(doc);
    }).toList();

    List<NutritionalValueModel> nutritionalTransfer =
        snapshotNutritrional.docs.map((DocumentSnapshot doc) {
      return NutritionalValueModel.fromSnapshot(doc);
    }).toList();

    for (var i = 0; i < ingredientsTransfer.length; i++) {
      Map<String, dynamic> ingredientsData = {
        "amount": ingredientsTransfer[i].amount,
        "product": ingredientsTransfer[i].product,
        "unit": ingredientsTransfer[i].unit,
      };
      await updateIngredient(recipeId, ingredientsTransfer[i].id,
          ingredientsData, true, 'recipes');
    }

    for (var i = 0; i < methodsTransfer.length; i++) {
      Map<String, dynamic> methodData = {
        "instruction": methodsTransfer[i].instruction,
        "step": methodsTransfer[i].step,
      };
      await updateMethod(
          recipeId, methodsTransfer[i].id, methodData, true, 'recipes');
    }

    for (var i = 0; i < nutritionalTransfer.length; i++) {
      Map<String, dynamic> nutritionData = {
        "amount": nutritionalTransfer[i].amount,
        "name": nutritionalTransfer[i].name,
        "unit": nutritionalTransfer[i].unit,
      };
      await updateNutritionalValue(
          recipeId, nutritionalTransfer[i].id, nutritionData, true, 'recipes');
    }
  }
}
