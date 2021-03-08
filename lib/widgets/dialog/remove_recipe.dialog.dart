import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';

class RemoveRecipe extends StatelessWidget {
  RemoveRecipe({this.recipe, this.role, this.function});
  final RecipeModel? recipe;
  final String? role;
  final Function(RecipeModel?)? function;

  final RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Waarschuwing"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("weet u zeker of u"),
          Text(recipe!.title!),
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
          color: ColorTheme.accentOrange,
          child: Text("verwijderen", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (role == "user") {
              await _recipeController.removeUserRecipe(recipe!.id, recipe!.url);

              Navigator.pop(context);
              function!(recipe);
            } else {
              await _recipeController.removeRecipe(recipe!.id, recipe!.url);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
