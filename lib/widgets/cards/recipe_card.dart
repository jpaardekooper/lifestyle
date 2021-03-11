import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_recipe_dialog.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard(
      {Key? key,
      required recipe,
      required user,
      this.on_Tap,
      this.userRecipe,
      this.function})
      : _recipe = recipe,
        _user = user,
        super(key: key);

  final RecipeModel _recipe;
  final AppUser _user;
  final VoidCallback? on_Tap;
  final bool? userRecipe;
  final Function(RecipeModel?)? function;

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  RecipeController _recipeController = RecipeController();
  bool? alreadySaved = false;
  String? imageUrl;

  void _editRecipeName(RecipeModel recipe, String? role) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditRecipe(
            recipe: recipe,
            isNewRecipe: false,
            user: widget._user,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorTheme.extraLightGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<String>(
                  future: _recipeController.getImage(widget._recipe.url),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: snapshot.data!,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (ctx, url, downloadProgress) => SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Text(
                        widget._recipe.title!,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    widget._recipe.tags!.isEmpty
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.only(top: 2.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor)),
                            child: Text(
                              widget._recipe.tags!.first,
                              style: TextStyle(
                                color: ColorTheme.grey,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.012,
                              ),
                            ),
                          )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                widget.userRecipe == false && widget._user.role == "user"
                    ? FutureBuilder<bool>(
                        future: _recipeController.checkFavoriteRecipe(
                            widget._recipe.id, widget._user.id),
                        builder: (context, snapshot) {
                          alreadySaved = snapshot.data;
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return IconButton(
                              icon: Icon(
                                alreadySaved!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: alreadySaved!
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                                size: 30,
                              ),
                              onPressed: () async {
                                if (alreadySaved!) {
                                  await _recipeController.removeFavoriteRecipe(
                                      widget._user.id, widget._recipe.id);

                                  if (widget.on_Tap != null) {
                                    widget.on_Tap!();
                                  }
                                } else {
                                  await _recipeController.addFavoriteRecipe(
                                      widget._user.id, widget._recipe.id);
                                }
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            );
                          }
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            child: Icon(
                              Icons.edit,
                              color: ColorTheme.grey,
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
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
