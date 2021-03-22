import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';

class RecipeUserRecipes extends StatefulWidget {
  final AppUser? user;

  RecipeUserRecipes({this.user});

  @override
  _RecipeUserRecipesState createState() => _RecipeUserRecipesState();
}

class _RecipeUserRecipesState extends State<RecipeUserRecipes> {
  final RecipeController _recipeController = RecipeController();

  StreamSubscription<QuerySnapshot>? _currentSubscription;
  List<RecipeModel> _recipes = <RecipeModel>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription = _recipeController
        .streamUserRecipes(widget.user!.id)
        .listen(_updateRecipeList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _recipes.clear();
  }

  void _updateRecipeList(QuerySnapshot snapshot) {
    setState(() {
      _recipes = _recipeController.getUserRecipeList(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RecipeGrid(
      recipeList: _recipes,
      userData: widget.user!,
      userRecipe: true,
    );
  }
}
