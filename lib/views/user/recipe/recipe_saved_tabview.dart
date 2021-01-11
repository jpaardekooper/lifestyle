import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';

class RecipeFavoritesView extends StatefulWidget {
  final String userId;

  RecipeFavoritesView({this.userId});

  @override
  _RecipeFavoritesViewState createState() => _RecipeFavoritesViewState();
}

class _RecipeFavoritesViewState extends State<RecipeFavoritesView> {
  final RecipeController _recipeController = RecipeController();
  List<RecipeModel> _savedRecipes = <RecipeModel>[];
  bool _isLoading = true;

  @override
  void initState() {
    _updateRecipes();
    super.initState();
  }

  @override
  void dispose() {
    _savedRecipes.clear();
    super.dispose();
  }

  _updateRecipes() async {
    _savedRecipes =
        await _recipeController.getUserFavoriteRecipe(widget.userId);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    if (_savedRecipes == null || _savedRecipes.isEmpty || _isLoading) {
      if (_savedRecipes.isEmpty) {
        return Center(
          child: BodyText(
            text: "Nog geen favoriete recepten toegevoegd",
          ),
        );
      }
      return Center(child: CircularProgressIndicator());
    } else {
      return RecipeGrid(
          recipeList: _savedRecipes,
          userData: _userData.data,
          userRecipe: false,
          onTap: () => _updateRecipes());
    }
  }
}
