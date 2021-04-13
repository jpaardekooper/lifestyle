import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_nutritional_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

import '../text/body_text.dart';

// ignore: must_be_immutable
class NutrionStream extends StatelessWidget {
  NutrionStream({required this.recipeId, this.userNewRecipe, this.collection});

  final String? recipeId;
  final bool? userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  final String? collection;

  late List<NutritionalValueModel> _nutritionalValueList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _foodPreparationController.streamNutritionalValue(
          recipeId, collection),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return IntroGreyText(text: "Geen voedingswaarde gevonden");
        } else {
          _nutritionalValueList =
              _foodPreparationController.fetchNutritionalValue(snapshot);
          if (_nutritionalValueList.isNotEmpty) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _nutritionalValueList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                NutritionalValueModel _nutritionalValue =
                    _nutritionalValueList[index];
                return NutritionalValueCard(
                  recipeId: recipeId,
                  nutritionalValue: _nutritionalValue,
                  collection: collection,
                  userNewRecipe: userNewRecipe,
                );
              },
            );
          } else {
            return IntroGreyText(text: "Nog geen voedingswaarde toegevoegd");
          }
        }
      },
    );
  }
}

// ignore: must_be_immutable
class NutritionalValueCard extends StatelessWidget {
  NutritionalValueCard({
    required this.recipeId,
    required this.nutritionalValue,
    required this.collection,
    this.userNewRecipe,
  });
  final String? recipeId;
  final bool? userNewRecipe;
  final NutritionalValueModel nutritionalValue;
  final String? collection;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  void onTapEdit(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditNutritional(
          recipeId: recipeId,
          nutritionalValue: nutritionalValue,
          newNutritional: false,
          collection: collection,
        );
      },
    );
  }

  void onTapDelete(BuildContext context) {
    _foodPreparationController.removeNutritionalValue(
      recipeId,
      nutritionalValue.id,
      collection,
    );
  }

  String? role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    role = _userData.data.role;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(
            text: "- " + nutritionalValue.name!,
          ),
          BodyText(
              text: nutritionalValue.amount! + " " + nutritionalValue.unit!),
          (role == 'user' && userNewRecipe == false) ||
                  (role == 'admin' && userNewRecipe == true)
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        onTapEdit(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () {
                        onTapDelete(context);
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
