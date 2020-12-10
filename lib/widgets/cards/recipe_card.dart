import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    Key key,
    @required RecipeModel recipe,
    @required String userId,
    this.on_Tap,
  })  : _recipe = recipe,
        _userId = userId,
        super(key: key);

  final RecipeModel _recipe;
  final String _userId;
  final VoidCallback on_Tap;

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  RecipeController _recipeController = RecipeController();
  bool alreadySaved = false;

  @override
  void initState() {
    checkFavoriteRecipes();
    super.initState();
  }

  checkFavoriteRecipes() async {
    alreadySaved = await _recipeController.checkFavoriteMarker(
        widget._recipe.id, widget._userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Color(0xffEFFAF6);
    Color recipeTitleColor = Color(0xff456A67);
    Color recipeTextColor = Color(0xff253635);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Expanded(
          flex: 3,
          child: CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            imageUrl: widget._recipe.url,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
            flex: 1,
            child: Row(children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            widget._recipe.title,
                            style: TextStyle(
                              color: recipeTitleColor,
                              fontFamily: 'Sofia Pro Regular Az',
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 15,
                          ),
                          Text(
                            '${widget._recipe.duration.toString()} min',
                            style: TextStyle(
                              color: recipeTextColor,
                              fontFamily: 'Sofia Pro Regular Az',
                            ),
                          ),
                        ]),
                      ])),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                    ),
                    onPressed: () {
                      if (alreadySaved) {
                        _recipeController.removeFavoriteRecipe(
                            widget._userId, widget._recipe.id);
                        widget.on_Tap();
                      } else {
                        _recipeController.addFavoriteRecipe(
                            widget._userId, widget._recipe.id);
                      }
                      checkFavoriteRecipes();
                    },
                  )),
            ])),
      ]),
    );
  }
}

// child: Column(
//     Row(
//       children: [
//         Text(_recipe.difficulty),
//         Text(_recipe.review.toString()),
//         Text(_recipe.duration.toString()),
//       ],
//     )
//   ],
// ),
