import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_nutritional_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

// ignore: must_be_immutable
class NutrionStream extends StatelessWidget {
  NutrionStream({@required this.recipeId, this.userNewRecipe});

  final String recipeId;
  final bool userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  List<NutritionalValueModel> _nutritionalValueList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _foodPreparationController.streamNutritionalValue(recipeId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Geen voedingswaarde gevonden");
        } else {
          _nutritionalValueList =
              _foodPreparationController.fetchNutritionalValue(snapshot);

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
                userNewRecipe: userNewRecipe,
              );
            },
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class NutritionalValueCard extends StatelessWidget {
  NutritionalValueCard({
    @required this.recipeId,
    @required this.nutritionalValue,
    this.userNewRecipe,
  });
  final String recipeId;
  final bool userNewRecipe;
  final NutritionalValueModel nutritionalValue;
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
        );
      },
    );
  }

  void onTapDelete(BuildContext context) {
    _foodPreparationController.removeNutritionalValue(
      recipeId,
      nutritionalValue.id,
    );
  }

  String role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    role = _userData.data.role;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutritionalValue.name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(nutritionalValue.amount + " " + nutritionalValue.unit),
          role == 'user' && userNewRecipe == false
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
