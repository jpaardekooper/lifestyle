import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/food_preparation_view.dart';
import 'package:lifestylescreening/widgets/cards/recipe_card.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class RecipeGrid extends StatelessWidget {
  const RecipeGrid(
      {Key key,
      @required List<RecipeModel> recipeList,
      @required AppUser userData,
      this.userRecipe,
      this.onTap,
      this.function})
      : _recipeList = recipeList,
        _userData = userData,
        super(key: key);

  final List<RecipeModel> _recipeList;
  final VoidCallback onTap;
  final AppUser _userData;
  final bool userRecipe;
  final Function(RecipeModel) function;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(20.0),
      //  physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _recipeList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final RecipeModel _recipe = _recipeList[index];
        return FadeInTransition(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InheritedDataProvider(
                  data: _userData,
                  child: FoodPreparationView(
                    recipe: _recipe,
                    userNewRecipe: userRecipe,
                  ),
                ),
              ),
            ),
            child: RecipeCard(
                recipe: _recipe,
                user: _userData,
                on_Tap: onTap,
                userRecipe: userRecipe,
                function: function),
          ),
        );
      },
    );
  }
}
