import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/remove_recipe.dialog.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    Key key,
    @required RecipeModel recipe,
    @required AppUser user,
    this.on_Tap,
    this.userRecipe,
  })  : _recipe = recipe,
        _user = user,
        super(key: key);

  final RecipeModel _recipe;
  final AppUser _user;
  final VoidCallback on_Tap;
  final bool userRecipe;

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  RecipeController _recipeController = RecipeController();
  bool alreadySaved = false;
  String imageUrl;

  @override
  void initState() {
    getImage();
    checkFavoriteRecipes();
    super.initState();
  }

  checkFavoriteRecipes() async {
    alreadySaved = await _recipeController.checkFavoriteRecipe(
        widget._recipe.id, widget._user.id);
    setState(() {});
  }

  void _editRecipeName(RecipeModel recipe, String role) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditRecipe(
            recipe: recipe,
            isNewRecipe: false,
            role: role,
          );
        });
  }

  void _removeRecipe(RecipeModel recipe, String role) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RemoveRecipe(recipe: recipe, role: role);
      },
    );
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
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: imageUrl == null
                  ? FittedBox(
                      child: CircularProgressIndicator(),
                      fit: BoxFit.scaleDown,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                    )),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
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
                widget.userRecipe == false && widget._user.role == "user"
                    ? Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            alreadySaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                          ),
                          onPressed: () {
                            checkFavoriteRecipes();
                            if (alreadySaved) {
                              _recipeController.removeFavoriteRecipe(
                                  widget._user.id, widget._recipe.id);
                              widget.on_Tap();
                            } else {
                              _recipeController.addFavoriteRecipe(
                                  widget._user.id, widget._recipe.id);
                            }
                          },
                        ))
                    : Row(
                        children: [
                          RawMaterialButton(
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _editRecipeName(
                                  widget._recipe, widget._user.role);
                            },
                            constraints: const BoxConstraints(
                                minWidth: 30.0, minHeight: 30.0),
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
                              _removeRecipe(widget._recipe, widget._user.role);
                            },
                            constraints: const BoxConstraints(
                                minWidth: 30.0, minHeight: 30.0),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            shape: CircleBorder(),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getImage() async {
    imageUrl =
        (await _recipeController.getImage(widget._recipe.url)).toString();
  }
}
