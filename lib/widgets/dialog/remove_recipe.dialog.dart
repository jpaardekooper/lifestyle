import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

class RemoveRecipe extends StatelessWidget {
  RemoveRecipe({
    this.recipe,
    this.role,
  });
  final RecipeModel? recipe;
  final String? role;

  final RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: H1Text(text: "Waarschuwing"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifestyleText(text: "Weet u zeker of u ${recipe!.title}"),
          LifestyleText(text: "wilt verwijderen?")
        ],
      ),
      actions: [
        TextButton(
          child: IntroGreyText(
            text: 'Cancel',
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: Text(
            'Verwijderen',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () async {
            if (role == "user") {
              await _recipeController.removeUserRecipe(
                  recipe!.id, recipe!.url, recipe!.userUploaded);

              Navigator.pop(context);
            } else {
              await _recipeController.removeRecipe(
                  recipe!.id, recipe!.url, recipe!.userUploaded);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
