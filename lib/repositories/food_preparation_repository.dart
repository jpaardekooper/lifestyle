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
    return snapshot.data.docs.map((DocumentSnapshot doc) {
      return IngredientsModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<MethodModel> fetchMethod(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((DocumentSnapshot doc) {
      return MethodModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<NutritionalValueModel> fetchNutritionalValue(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((DocumentSnapshot doc) {
      return NutritionalValueModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamIngredients(String recipeId) {
    return FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection("ingredients")
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamMethod(String recipeId) {
    return FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection("method")
        .orderBy('step', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamNutritionalValue(String recipeId) {
    return FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection("nutritionalValue")
        .snapshots();
  }

  @override
  Future<void> updateIngredient(String recipeId, String ingredientId, Map data,
      bool newIngriendient) async {
    if (newIngriendient) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('ingredients')
          .doc()
          .set(data)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('ingredients')
          .doc(ingredientId)
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> updateMethod(
      String recipeId, String methodId, Map data, bool newMethod) async {
    if (newMethod) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('method')
          .doc()
          .set(data)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('method')
          .doc(methodId)
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> updateNutritionalValue(String recipeId, String nutritionalId,
      Map data, bool newNutritional) async {
    if (newNutritional) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('nutritionalValue')
          .doc()
          .set(data)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .collection('nutritionalValue')
          .doc(nutritionalId)
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> deleteIngredient(String recipeId, String ingredientId) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection('ingredients')
        .doc(ingredientId)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> deleteMethod(String recipeId, String methodId) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection('method')
        .doc(methodId)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> deleteNutritrionalValue(
      String recipeId, String nutritionalId) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection('nutritionalValue')
        .doc(nutritionalId)
        .delete()
        .catchError((e) {});
  }
}
