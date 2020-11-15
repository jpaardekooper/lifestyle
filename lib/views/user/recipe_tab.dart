import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/food_preparation_view.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  RecipeController _recipeController = RecipeController();

  Future<void> _refreshData() async {
    setState(() {
      return _recipeController.getRecipeListOnce();
    });
  }

  Widget gridViewBuilder(List<RecipeModel> _recipeList, AppUser _userData) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _recipeList.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        RecipeModel _recipe = _recipeList[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InheritedDataProvider(
                data: _userData,
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
              Text(_recipe.title),
              Row(
                children: [
                  Text(_recipe.difficulty),
                  Text(_recipe.review.toString()),
                  Text(_recipe.duration.toString()),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //      all recipes
          Text("Recipe tab"),

          RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<List<RecipeModel>>(
              future: _recipeController.getRecipeListOnce(),
              builder: (context, snapshot) {
                List<RecipeModel> _recipeList = snapshot.data;
                if (_recipeList == null || _recipeList.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  return gridViewBuilder(_recipeList, _userData.data);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
