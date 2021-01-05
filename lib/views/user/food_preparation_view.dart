import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/cards/ingredients_card.dart';
import 'package:lifestylescreening/widgets/cards/method_card.dart';
import 'package:lifestylescreening/widgets/cards/nutritional_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_ingredient_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/edit_method_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/edit_nutritional_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_large_wave_painter.dart';

import '../../widgets/text/h1_text.dart';
import '../../widgets/text/h2_text.dart';

class FoodPreparationView extends StatefulWidget {
  FoodPreparationView({@required this.recipe, this.userNewRecipe});
  final RecipeModel recipe;
  final bool userNewRecipe;

  @override
  _FoodPreparationViewState createState() => _FoodPreparationViewState();
}

class _FoodPreparationViewState extends State<FoodPreparationView> {
  RecipeController _recipeController = RecipeController();
  String imageUrl;

  void onTap() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  void addIngredientsData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditIngredient(
          recipeId: widget.recipe.id,
          ingredient: IngredientsModel(),
          newIngredient: true,
        );
      },
    );
  }

  void addMethodData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditMethod(
          recipeId: widget.recipe.id,
          method: MethodModel(),
          newMethod: true,
        );
      },
    );
  }

  void addNutritionalData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditNutritional(
          recipeId: widget.recipe.id,
          nutritionalValue: NutritionalValueModel(),
          newNutritional: true,
        );
      },
    );
  }

  Widget headerIngredients() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Ingrediënten"),
        role == "user" && widget.userNewRecipe == false
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addIngredientsData,
              )
      ],
    );
  }

  Widget headerMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Methode"),
        role == "user" && widget.userNewRecipe == false
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addMethodData,
              )
      ],
    );
  }

  Widget headerNutritionalValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Voedingswaarde per portie"),
        role == "user" && widget.userNewRecipe == false
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: addNutritionalData,
              )
      ],
    );
  }

  String role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    role = _userData.data.role;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(HealthpointIcons.arrowLeftIcon),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                ),
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: ColorTheme.extraLightGreen,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorTheme.extraLightGreen,
                    ),
                    child: H1Text(text: widget.recipe.title),
                  ),
                  background: imageUrl == null
                      ? CircularProgressIndicator()
                      : CachedNetworkImage(
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          imageUrl: imageUrl,
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
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      headerIngredients(),
                      InheritedDataProvider(
                        data: _userData.data,
                        child: IngredientsStream(
                          recipeId: widget.recipe.id,
                          userNewRecipe: widget.userNewRecipe,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                      ),
                      headerMethods(),
                      InheritedDataProvider(
                        data: _userData.data,
                        child: MethodStream(
                          recipeId: widget.recipe.id,
                          userNewRecipe: widget.userNewRecipe,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                      ),
                      headerNutritionalValue(),
                      InheritedDataProvider(
                        data: _userData.data,
                        child: NutrionStream(
                          recipeId: widget.recipe.id,
                          userNewRecipe: widget.userNewRecipe,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // CustomScrollView(
          //   slivers: [
          //     SliverAppBar(
          //       leading: IconButton(
          //           icon: Icon(Icons.filter_1),
          //           onPressed: () {
          //             // Do something
          //           }),
          //       expandedHeight: 220.0,
          //       floating: true,
          //       pinned: true,
          //       snap: true,
          //       elevation: 50,
          //       backgroundColor: Colors.pink,
          //       flexibleSpace: FlexibleSpaceBar(
          //         centerTitle: true,
          //         title: Text('Title',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 16.0,
          //             )),
          //         background: imageUrl == null
          //             ? Image.network(
          //                 "https://firebasestorage.googleapis.com/v0/b/lifestyle-screening.appspot.com/o/recipeImages%2Fplaceholder.png?alt=media&token=f8dabc81-d175-4d86-91e0-83442488bd6e",
          //                 fit: BoxFit.cover,
          //               )
          //             : Image.network(
          //                 imageUrl,
          //                 fit: BoxFit.cover,
          //               ),
          //       ),
          //     ),
          //     SliverList(
          //       delegate: SliverChildListDelegate(_buildlist(_userData)),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }

  getImage() async {
    imageUrl = (await _recipeController.getImage(widget.recipe.url)).toString();
    setState(() {});
  }
}
