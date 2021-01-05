import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/widgets/recipe_grid.dart';

class RecipeFeedView extends StatefulWidget {
  @override
  _RecipeFeedViewState createState() => _RecipeFeedViewState();
}

class _RecipeFeedViewState extends State<RecipeFeedView> {
  RecipeController _recipeController = RecipeController();

  Future<void> _refreshData() async {
    setState(() {
      return _recipeController.getRecipeListOnce();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return Center(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<RecipeModel>>(
          future: _recipeController.getRecipeListOnce(),
          builder: (context, snapshot) {
            List<RecipeModel> _recipeList = snapshot.data;
            if (_recipeList == null || _recipeList.isEmpty) {
              return CircularProgressIndicator();
            } else {
              return RecipeGrid(
                recipeList: _recipeList,
                userData: _userData.data,
                userRecipe: false,
              );
            }
          },
        ),
      ),
    );
  }
}
