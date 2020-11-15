import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/food_preparation_view.dart';
import 'package:lifestylescreening/widgets/dialog/edit_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/remove_recipe.dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeView extends StatefulWidget {
  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<RecipeModel> _recipesList = <RecipeModel>[];

  final RecipeController _recipeController = RecipeController();

  @override
  void initState() {
    _currentSubscription =
        _recipeController.streamRecipes().listen(_updateRecipes);
    super.initState();
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    super.dispose();
  }

  void _updateRecipes(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _recipesList = _recipeController.getRecipeList(snapshot);
    });
  }

  void _editRecipeName(RecipeModel recipe) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditRecipe(
            recipe: recipe,
            isNewRecipe: false,
          );
        });
  }

  void _addNewRecipe() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditRecipe(
            recipe: RecipeModel(),
            isNewRecipe: true,
          );
        });
  }

  void _removeRecipe(RecipeModel recipe) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RemoveRecipe(recipe: recipe);
        });
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1280),
          child: _isLoading
              ? CircularProgressIndicator()
              : _recipesList.isNotEmpty
                  ? GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: false,
                      itemCount: _recipesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        RecipeModel _recipe = _recipesList[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InheritedDataProvider(
                                data: _userData.data,
                                child: FoodPreparationView(
                                  recipe: _recipe,
                                ),
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                imageUrl: _recipe.url,
                                fit: BoxFit.cover,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(_recipe.title),
                                      Text(_recipe.difficulty),
                                      Row(
                                        children: [
                                          Text(_recipe.review.toString()),
                                          Text(_recipe.duration.toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          RawMaterialButton(
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _editRecipeName(_recipe);
                                            },
                                            constraints: const BoxConstraints(
                                                minWidth: 30.0,
                                                minHeight: 30.0),
                                            elevation: 2.0,
                                            fillColor: Colors.white,
                                            shape: CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _removeRecipe(_recipe);
                                            },
                                            constraints: const BoxConstraints(
                                                minWidth: 30.0,
                                                minHeight: 30.0),
                                            elevation: 2.0,
                                            fillColor: Colors.white,
                                            shape: CircleBorder(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('Geen recepten gevonden'),
                      //onPressed: _onAddRandomRecipesPressed,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewRecipe(),
        child: Icon(Icons.add),
      ),
    );
  }
}
