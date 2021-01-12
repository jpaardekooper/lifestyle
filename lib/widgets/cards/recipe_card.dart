import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_recipe_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/remove_recipe.dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RecipeCard extends StatefulWidget {
  const RecipeCard(
      {Key key,
      @required recipe,
      @required user,
      this.on_Tap,
      this.userRecipe,
      this.function})
      : _recipe = recipe,
        _user = user,
        super(key: key);

  final RecipeModel _recipe;
  final AppUser _user;
  final VoidCallback on_Tap;
  final bool userRecipe;
  final Function(RecipeModel) function;

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  RecipeController _recipeController = RecipeController();
  bool alreadySaved = false;
  String imageUrl;

  @override
  void initState() {
    // checkFavoriteRecipes();
    super.initState();
  }

  // checkFavoriteRecipes() async {
  //   alreadySaved = await _recipeController.checkFavoriteRecipe(
  //       widget._recipe.id, widget._user.id);
  // }

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
        return RemoveRecipe(
            recipe: recipe, role: role, function: widget.function);
      },
    );
  }

  // Future<Uri> downloadImageUrl(String img) {
  //   return fb
  //       .storage()
  //       .refFromURL('gs://lifestyle-screening.appspot.com/')
  //       .child("recipeImages/$img")
  //       .getDownloadURL();
  // }

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
      //  clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child:
                //      kIsWeb
                // ? FutureBuilder<Uri>(
                //     future: downloadImageUrl(widget._recipe.url),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return SizedBox(
                //           width: 50,
                //           height: 50,
                //           child: Center(child: CircularProgressIndicator()),
                //         );
                //       } else {
                //         return CachedNetworkImage(
                //           imageUrl: snapshot.data.toString(),
                //           fit: BoxFit.cover,
                //           progressIndicatorBuilder:
                //               (ctx, url, downloadProgress) => SizedBox(
                //             width: 50,
                //             height: 50,
                //             child: Center(
                //               child: CircularProgressIndicator(
                //                   value: downloadProgress.progress),
                //             ),
                //           ),
                //           errorWidget: (context, url, error) =>
                //               Icon(Icons.error),
                //         );
                //       }
                //     },
                //   )
                // :
                FutureBuilder<String>(
              future: _recipeController.getImage(widget._recipe.url),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data.toString(),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (ctx, url, downloadProgress) =>
                        SizedBox(
                      width: 50,
                      height: 50,
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
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget._recipe.duration.toString()} min',
                              style: TextStyle(
                                color: recipeTextColor,
                                fontFamily: 'Sofia Pro Regular Az',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  widget.userRecipe == false && widget._user.role == "user"
                      ? Expanded(
                          flex: 1,
                          child: FutureBuilder<bool>(
                            future: _recipeController.checkFavoriteRecipe(
                                widget._recipe.id, widget._user.id),
                            builder: (context, snapshot) {
                              alreadySaved = snapshot.data;
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return IconButton(
                                  icon: Icon(
                                    alreadySaved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: alreadySaved ? Colors.red : null,
                                  ),
                                  onPressed: () async {
                                    //     await checkFavoriteRecipes();
                                    if (alreadySaved) {
                                      await _recipeController
                                          .removeFavoriteRecipe(widget._user.id,
                                              widget._recipe.id);

                                      if (widget.on_Tap != null) {
                                        widget.on_Tap();
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
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                              onPressed: () async {
                                _removeRecipe(
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
          ),
        ],
      ),
    );
  }
}
