import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';

class RecipeFeedView extends StatefulWidget {
  @override
  _RecipeFeedViewState createState() => _RecipeFeedViewState();
}

class _RecipeFeedViewState extends State<RecipeFeedView> {
  RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return SingleChildScrollView(
      child: FutureBuilder<List<RecipeModel>>(
        future: _recipeController.getRecipeListOnce(),
        builder: (context, snapshot) {
          final List<RecipeModel>? _recipeList = snapshot.data;
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return RecipeGrid(
              recipeList: _recipeList,
              userData: _userData!.data,
              userRecipe: false,
              onTap: null,
            );
          }
        },
      ),
    );
  }
}
