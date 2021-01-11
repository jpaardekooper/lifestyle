import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';

class RecipeUserRecipes extends StatefulWidget {
  @override
  _RecipeUserRecipesState createState() => _RecipeUserRecipesState();
}

class _RecipeUserRecipesState extends State<RecipeUserRecipes> {
  final RecipeController _recipeController = RecipeController();
  List<RecipeModel> _recipeList = [];

  void removeData(RecipeModel recipe) {
    if (_recipeList.isNotEmpty && _recipeList.contains(recipe)) {
      _recipeList.remove(recipe);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return FutureBuilder<List<RecipeModel>>(
      future: _recipeController.getUserRecipes(_userData.data.id),
      builder: (context, snapshot) {
        _recipeList = snapshot.data;
        if (_recipeList == null || _recipeList.isEmpty) {
          return Center(
            child: BodyText(
              text: "Nog geen eigen recepten toegevoegd",
            ),
          );
        } else {
          return RecipeGrid(
            recipeList: _recipeList,
            userData: _userData.data,
            userRecipe: true,
            function: removeData,
          );
        }
      },
    );
  }
}
