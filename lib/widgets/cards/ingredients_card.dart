import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_ingredient_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

import '../text/body_text.dart';

// ignore: must_be_immutable
class IngredientsStream extends StatelessWidget {
  IngredientsStream(
      {required this.recipeId, this.userNewRecipe, this.collection});

  final String? recipeId;
  final bool? userNewRecipe;
  final String? collection;

  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  List<IngredientsModel> _ingredientsList = [];
  String? role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    role = _userData.data.role;
    return StreamBuilder<QuerySnapshot>(
      stream:
          _foodPreparationController.streamIngredients(recipeId, collection),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return IntroGreyText(text: "Geen ingredienten gevonden");
        } else {
          _ingredientsList =
              _foodPreparationController.fetchIngredients(snapshot);
          if (_ingredientsList.isNotEmpty) {
            return Table(
              defaultColumnWidth:
                  kIsWeb ? const FlexColumnWidth(1.0) : IntrinsicColumnWidth(),
              border: TableBorder.all(color: ColorTheme.orange, width: 3.0),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: fillTable(_ingredientsList, context),
            );
          } else {
            return IntroGreyText(text: "Nog geen toegevoegde ingrediënten");
          }
        }
      },
    );
  }

  void onTapEdit(IngredientsModel ingredient, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditIngredient(
          recipeId: recipeId,
          ingredient: ingredient,
          newIngredient: false,
          collection: collection,
        );
      },
    );
  }

  void onTapDelete(IngredientsModel ingredient) {
    _foodPreparationController.removeIngredient(
        recipeId, ingredient.id, collection);
  }

  List<TableRow> fillTable(List<IngredientsModel> ingredient, context) {
    List<TableRow>? tableRows = [];
    List<TableCell>? tableCells;

    for (var i = 0; i < ingredient.length; i++) {
      tableCells = [];
      tableCells.add(
        TableCell(
            child: Container(
                alignment: Alignment.centerRight,
                padding:
                    EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                child: BodyText(
                    text: ingredient[i].amount! + " " + ingredient[i].unit!))),
      );
      tableCells.add(
        TableCell(
            child: Container(
                padding:
                    EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                child: BodyText(text: ingredient[i].product))),
      );
      if ((role == 'user' && userNewRecipe == false) ||
          (role == 'admin' && userNewRecipe == true)) {
      } else {
        tableCells.add(
          TableCell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    onTapEdit(ingredient[i], context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () {
                    onTapDelete(ingredient[i]);
                  },
                ),
              ],
            ),
          ),
        );
      }
      tableRows.add(
        TableRow(
          children: tableCells,
        ),
      );
    }
    return tableRows;
  }
}
