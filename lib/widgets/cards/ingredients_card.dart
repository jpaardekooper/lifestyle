import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_ingredient_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

import '../text/body_text.dart';

// ignore: must_be_immutable
class IngredientsStream extends StatelessWidget {
  IngredientsStream({@required this.recipeId, this.userNewRecipe});

  final String recipeId;
  final bool userNewRecipe;

  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  List<IngredientsModel> _ingredientsList;
  String role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    role = _userData.data.role;
    return StreamBuilder<QuerySnapshot>(
      stream: _foodPreparationController.streamIngredients(recipeId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("geen ingredienten gevonden");
        } else {
          _ingredientsList =
              _foodPreparationController.fetchIngredients(snapshot);

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _ingredientsList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              IngredientsModel _ingredient = _ingredientsList[index];
              return IngredientsCard(
                recipeId: recipeId,
                ingredient: _ingredient,
                role: role,
                userNewRecipe: userNewRecipe,
              );
            },
          );
        }
      },
    );
  }
}

class IngredientsCard extends StatelessWidget {
  IngredientsCard(
      {@required this.recipeId,
      @required this.ingredient,
      @required this.role,
      this.userNewRecipe});
  final String recipeId;
  final IngredientsModel ingredient;
  final String role;
  final bool userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  void onTapEdit(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditIngredient(
          recipeId: recipeId,
          ingredient: ingredient,
          newIngredient: false,
        );
      },
    );
  }

  void onTapDelete() {
    _foodPreparationController.removeIngredient(recipeId, ingredient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              BodyText(text: "• "),
              BodyText(text: ingredient.amount.toString()),
              BodyText(text: " "),
              BodyText(text: ingredient.unit),
              BodyText(text: " "),
              BodyText(text: ingredient.product),
            ],
          ),
          role == 'user' && userNewRecipe == false
              ? Container()
              : Row(
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
                        onTapDelete();
                      },
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
