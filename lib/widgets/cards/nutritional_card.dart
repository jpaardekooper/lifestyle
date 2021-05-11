import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_nutritional_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

import '../text/body_text.dart';

// ignore: must_be_immutable
class NutrionStream extends StatelessWidget {
  NutrionStream({required this.recipe, this.userNewRecipe, this.collection});

  final RecipeModel recipe;
  final bool? userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  final String? collection;

  late List<NutritionalValueModel> _nutritionalValueList;
  String? role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    role = _userData.data.role;
    return StreamBuilder<QuerySnapshot>(
      stream: _foodPreparationController.streamNutritionalValue(
          recipe.id, collection),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return IntroGreyText(text: "Geen voedingswaarde gevonden");
        } else {
          _nutritionalValueList =
              _foodPreparationController.fetchNutritionalValue(snapshot);
          _nutritionalValueList.sort((a, b) => b.amount!.compareTo(a.amount!));
          if (_nutritionalValueList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  defaultColumnWidth: kIsWeb
                      ? const FlexColumnWidth(1.0)
                      : IntrinsicColumnWidth(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: fillTable(_nutritionalValueList, context, 1),
                ),
                recipe.portion == 1
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          H2Text(text: "Voedingswaarde per portie"),
                          Table(
                            defaultColumnWidth: kIsWeb
                                ? const FlexColumnWidth(1.0)
                                : IntrinsicColumnWidth(),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: fillTable(
                                _nutritionalValueList, context, recipe.portion),
                          ),
                        ],
                      ),
              ],
            );
          } else {
            return IntroGreyText(text: "Nog geen voedingswaarde toegevoegd");
          }
        }
      },
    );
  }

  void onTapEdit(BuildContext context, NutritionalValueModel nutritionalValue) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditNutritional(
          recipeId: recipe.id,
          nutritionalValue: nutritionalValue,
          newNutritional: false,
          collection: collection,
        );
      },
    );
  }

  void onTapDelete(NutritionalValueModel nutritionalValue) {
    _foodPreparationController.removeNutritionalValue(
      recipe.id,
      nutritionalValue.id,
      collection,
    );
  }

  List<TableRow> fillTable(
      List<NutritionalValueModel> nutritionalValue, context, int? _divider) {
    List<TableRow>? tableRows = [];
    List<TableCell>? tableCells;

    for (var i = 0; i < nutritionalValue.length; i++) {
      tableCells = [];
      tableCells.add(
        TableCell(
            child: Container(
                padding:
                    EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                child: BodyText(text: "- ${nutritionalValue[i].name}"))),
      );
      tableCells.add(
        TableCell(
            child: Container(
                alignment: Alignment.centerRight,
                padding:
                    EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                child: BodyText(
                    text:
                        // ignore: lines_longer_than_80_chars
                        "${(nutritionalValue[i].amount! / _divider!).toStringAsFixed(1)} ${nutritionalValue[i].unit!}"))),
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
                    onTapEdit(context, nutritionalValue[i]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  color: Colors.red,
                  onPressed: () {
                    onTapDelete(nutritionalValue[i]);
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
