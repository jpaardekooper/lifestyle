import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

class RemoveRecipe extends StatelessWidget {
  RemoveRecipe({this.recipe, this.role});
  final RecipeModel recipe;
  final String role;

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
            if (role == "user") {
              _recipeController
                  .removeUserRecipe(recipe.id, recipe.url)
                  .then((value) => Navigator.of(context).pop());
            } else {
              _recipeController
                  .removeRecipe(recipe.id, recipe.url)
                  .then((value) => Navigator.of(context).pop());
            }
          },
        ),
      ],
    );
  }
}
