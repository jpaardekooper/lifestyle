import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

class ApproveRecipe extends StatefulWidget {
  ApproveRecipe({required this.recipe});
  final RecipeModel recipe;
  @override
  _ApproveRecipeState createState() => _ApproveRecipeState();
}

class _ApproveRecipeState extends State<ApproveRecipe> {
  RecipeController _recipeController = RecipeController();
  FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: H1Text(text: "Recept goedkeuren"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LifestyleText(text: "Weet u zeker dat u ${widget.recipe.title}"),
          LifestyleText(text: "wilt goedkeuren?")
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
            'Goedkeuren',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () async {
            Map<String, dynamic> data = {
              "title": widget.recipe.title,
              "url": widget.recipe.url,
              "duration": widget.recipe.duration,
              "difficulty": widget.recipe.difficulty,
              "published": false,
              "date": DateTime.now(),
              "tags": widget.recipe.tags,
              "userId": widget.recipe.userId,
            };

            Map<String, dynamic> resetSubmission = {
              "submitted": false,
            };

            await _recipeController.updateUserRecipe(
                widget.recipe.id, resetSubmission, false);

            await _recipeController
                .updateRecipe(widget.recipe.id, data, true)
                .then((value) =>
                    _foodPreparationController.transferRecipe(widget.recipe.id))
                .whenComplete(() => Navigator.of(context).pop(true));
          },
        ),
      ],
    );
  }
}
