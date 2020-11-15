import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/cards/ingredients_card.dart';
import 'package:lifestylescreening/widgets/cards/method_card.dart';
import 'package:lifestylescreening/widgets/cards/nutritional_card.dart';
import 'package:lifestylescreening/widgets/dialog/edit_ingredient_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/edit_method_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/edit_nutritional_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class FoodPreparationView extends StatefulWidget {
  FoodPreparationView({@required this.recipe});
  final RecipeModel recipe;

  @override
  _FoodPreparationViewState createState() => _FoodPreparationViewState();
}

class _FoodPreparationViewState extends State<FoodPreparationView> {
  void onTap() {
    Navigator.pop(context);
  }

  void addIngredientsData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditIngredient(
          recipeId: widget.recipe.id,
          ingredient: IngredientsModel(),
          newIngredient: true,
        );
      },
    );
  }

  void addMethodData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditMethod(
          recipeId: widget.recipe.id,
          method: MethodModel(),
          newMethod: true,
        );
      },
    );
  }

  void addNutritionalData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditNutritional(
          recipeId: widget.recipe.id,
          nutritionalValue: NutritionalValueModel(),
          newNutritional: true,
        );
      },
    );
  }

  Widget header() {
    return Text(
      // ignore: lines_longer_than_80_chars
      "Vergroot uw aantal groenten en ontvang drie van uw vijf-per-dag met deze geurige vetarme vegatarische curry",
    );
  }

  Widget headerIngredients() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Ingrediënten"),
        role == "user"
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addIngredientsData,
              )
      ],
    );
  }

  Widget headerMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Methode"),
        role == "user"
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addMethodData,
              )
      ],
    );
  }

  Widget headerNutritionalValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Voedingswaarde per portie"),
        role == "user"
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addNutritionalData,
              )
      ],
    );
  }

  String role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    role = _userData.data.role;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              Divider(),
              headerIngredients(),
              InheritedDataProvider(
                data: _userData.data,
                child: IngredientsStream(
                  recipeId: widget.recipe.id,
                ),
              ),
              Divider(),
              headerMethods(),
              // streamMethods(),

              InheritedDataProvider(
                data: _userData.data,
                child: MethodStream(recipeId: widget.recipe.id),
              ),
              Divider(),
              headerNutritionalValue(),
              // streamNutritionalValues()

              InheritedDataProvider(
                data: _userData.data,
                child: NutrionStream(
                  recipeId: widget.recipe.id,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
