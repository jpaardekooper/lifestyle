import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class SubmittedRecipeView extends StatefulWidget {
  SubmittedRecipeView({this.user});

  final AppUser? user;

  @override
  _SubmittedRecipeViewState createState() => _SubmittedRecipeViewState();
}

// flutter run -d chrome --web-renderer=html

class _SubmittedRecipeViewState extends State<SubmittedRecipeView> {
  final RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<RecipeModel>>(
        future: _recipeController.getSubmittedRecipeListOnce(),
        builder: (context, snapshot) {
          final List<RecipeModel>? _recipeList = snapshot.data;
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if(_recipeList!.isEmpty){
              return Center(child: H1Text(text: "Geen opgestuurde recepten"),);
            }
            return RecipeGrid(
              recipeList: _recipeList,
              userData: widget.user!,
              userRecipe: true,
              onTap: null,
            );
          }
        },
      ),
    );
  }
}
