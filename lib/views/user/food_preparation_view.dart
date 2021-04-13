import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_feed_buildup.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

import '../../widgets/text/h1_text.dart';

class FoodPreparationView extends StatefulWidget {
  FoodPreparationView({required this.recipe, this.userNewRecipe});
  final RecipeModel recipe;
  final bool? userNewRecipe;

  @override
  _FoodPreparationViewState createState() => _FoodPreparationViewState();
}

class _FoodPreparationViewState extends State<FoodPreparationView> {
  RecipeController _recipeController = RecipeController();
  String? imageUrl;
  bool? submitted;
  String? collection;

  @override
  void initState() {
    submitted = widget.recipe.submittedForReview;
    collection = widget.userNewRecipe! ? "createdRecipes" : "recipes";
    super.initState();
  }

  void cancelUpload() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: H1Text(text: "Review van Recept annuleren"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LifestyleText(text: "Uw recept is opgestuurd voor review!"),
                SizedBox(height: 10),
                LifestyleText(
                    text:
                        // ignore: lines_longer_than_80_chars
                        'Als u de review van uw recept wilt annuleren, kan dit gedaan worden door op "Review annuleren" te klikken.')
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: IntroGreyText(text: "Cancel"),
              ),
              ElevatedButton(
                child: Text('Review annuleren'),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
                onPressed: () {
                  setState(() {
                    submitted = false;
                  });
                  Map<String, dynamic> data = {
                    'submitted': false,
                  };
                  _recipeController
                      .updateUserRecipe(widget.recipe.id, data, false)
                      .then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: ColorTheme.lightOrange,
                                  content: Text(
                                    "Review geannuleerd!",
                                    style: TextStyle(
                                        color: ColorTheme.darkGrey,
                                        fontSize: 18),
                                  ),
                                ),
                              ));
                  Future.delayed(Duration(milliseconds: 1500), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void confirmUpload() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: H1Text(text: "Recept opsturen voor review"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LifestyleText(
                    text:
                        // ignore: lines_longer_than_80_chars
                        "Als u er van overtuigd bent dat uw recept een gezond alternatief is, stuur deze dan op voor review!"),
                SizedBox(height: 10),
                LifestyleText(
                    text:
                        // ignore: lines_longer_than_80_chars
                        "Als uw recept wordt goedgekeurd, wordt het recept openbaar gezet zodat deze voor iedereen zichtbaar is.")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: IntroGreyText(text: "Cancel"),
              ),
              ElevatedButton(
                child: Text('Indienen'),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
                onPressed: () {
                  setState(() {
                    submitted = true;
                  });
                  Map<String, dynamic> data = {
                    'submitted': true,
                  };
                  _recipeController
                      .updateUserRecipe(widget.recipe.id, data, false)
                      .then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: ColorTheme.lightOrange,
                                  content: Text(
                                    "Recept opgestuurd voor review!",
                                    style: TextStyle(
                                        color: ColorTheme.darkGrey,
                                        fontSize: 18),
                                  ),
                                ),
                              ));
                  Future.delayed(Duration(milliseconds: 1500), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  String? role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;
    role = _userData.data.role;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: widget.userNewRecipe == true && role == "user"
          ? FloatingActionButton(
              backgroundColor: submitted!
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
              onPressed: () => submitted! ? cancelUpload() : confirmUpload(),
              child: Icon(
                Icons.upload_rounded,
                color: Colors.white,
              ),
            )
          : Container(),
      body: FutureBuilder<String>(
          future: _recipeController.getImage(widget.recipe.url),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              imageUrl = snapshot.data.toString();
            }
            return DefaultTabController(
              length: 1,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      leading: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(HealthpointIcons.arrowLeftIcon),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.of(context).pop();
                        },
                      ),
                      expandedHeight: kIsWeb ? 500 : 250.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: ColorTheme.extraLightGreen,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: ColorTheme.extraLightGreen,
                          ),
                          child: H1Text(text: widget.recipe.title),
                        ),
                        background: snapshot.data == null
                            ? Center(child: CircularProgressIndicator())
                            : CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                imageUrl: imageUrl!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ];
                },
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomPaint(
                          size: Size(size.width, size.height),
                          painter: BottomLargeWavePainter(
                            color: ColorTheme.extraLightGreen,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: RecipeBuildUp(
                        recipe: widget.recipe,
                        user: _userData.data,
                        userNewRecipe: widget.userNewRecipe,
                        collection: collection,
                        imageUrl: imageUrl,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
