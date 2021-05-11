import 'package:flutter/foundation.dart';
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
              "portion": widget.recipe.portion,
              "userUploaded": true,
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
                .whenComplete(() => kIsWeb
                    ? saveRecipeDialog()
                    : Navigator.of(context).pop(true));
          },
        ),
      ],
    );
  }

  void saveRecipeDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: H1Text(text: "Recept opslaan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LifestyleText(
                  text:
                      // ignore: lines_longer_than_80_chars
                      "Wilt u ${widget.recipe.title} opslaan als tekstbestand?"),
            ],
          ),
          actions: [
            TextButton(
              child: IntroGreyText(
                text: 'Cancel',
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(
                'Opslaan',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.020,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor),
              onPressed: () => saveRecipe(),
            ),
          ],
        );
      },
    ).then((value) {
      if (value) Navigator.of(context).pop(true);
    });
  }

  Future<void> saveRecipe() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   // String recipeString = jsonEncode(widget.recipe);
  //   String recipeString = "test";

  //   File file = File('Downloads/${widget.recipe.title}');
  //   await file.writeAsString(recipeString);
  }
}
