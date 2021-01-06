import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/food_preparation_view.dart';
import 'package:lifestylescreening/widgets/cards/recipe_card.dart';
import 'package:lifestylescreening/widgets/dialog/edit_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeView extends StatefulWidget {
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  final RecipeController _recipeController = RecipeController();

  StreamSubscription<QuerySnapshot> _currentSubscription;
  List<RecipeModel> _recipes = <RecipeModel>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        _recipeController.streamRecipes().listen(_updateSurveyList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _recipes.clear();
  }

  void _updateSurveyList(QuerySnapshot snapshot) {
    setState(() {
      _recipes = _recipeController.getRecipeList(snapshot);
    });
  }

  void _addNewRecipe(String role) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditRecipe(
          recipe: RecipeModel(),
          isNewRecipe: true,
          role: role,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewRecipe(_userData.data.role),
        child: Icon(Icons.add),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20.0),
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _recipes.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          RecipeModel _recipe = _recipes[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InheritedDataProvider(
                  data: _userData.data,
                  child: FoodPreparationView(
                    recipe: _recipe,
                    userNewRecipe: false,
                  ),
                ),
              ),
            ),
            child: RecipeCard(
                recipe: _recipe, user: _userData.data, userRecipe: false),
          );
        },
      ),
    );
  }
}
