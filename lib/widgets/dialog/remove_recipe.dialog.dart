import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

class RemoveRecipe extends StatelessWidget {
  RemoveRecipe({this.recipe});
  final RecipeModel recipe;

  final RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Waarschuwing"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("weet u zeker of u"),
          Text(recipe.title),
          Text("wilt verwijderen?")
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("verwijderen"),
          onPressed: () {
            _recipeController
                .removeRecipe(recipe.id)
                .then((value) => Navigator.of(context).pop());
          },
        ),
      ],
    );
  }
}
