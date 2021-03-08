import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';

class RecipeFavoritesView extends StatefulWidget {
  final String? userId;

  RecipeFavoritesView({this.userId});

  @override
  _RecipeFavoritesViewState createState() => _RecipeFavoritesViewState();
}

class _RecipeFavoritesViewState extends State<RecipeFavoritesView> {
  final RecipeController _recipeController = RecipeController();
  List<RecipeModel>? _savedRecipes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _savedRecipes!.clear();
    super.dispose();
  }

  _updateRecipes() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return FutureBuilder<List<RecipeModel>>(
      future: _recipeController.getUserFavoriteRecipe(widget.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _savedRecipes = snapshot.data;
          if (_savedRecipes!.isEmpty) {
            return Center(
              child: BodyText(
                text: "Nog geen recepten als favoriete ingesteld",
              ),
            );
          } else {
            return RecipeGrid(
                recipeList: _savedRecipes,
                userData: _userData!.data,
                userRecipe: false,
                onTap: _updateRecipes);
          }
        }
      },
    );
  }
}
