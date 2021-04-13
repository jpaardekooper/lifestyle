import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
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
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class RecipeBuildUp extends StatelessWidget {
  RecipeBuildUp(
      {this.user,
      this.collection,
      required this.recipe,
      this.userNewRecipe,
      this.imageUrl});

  final AppUser? user;
  final String? collection;
  final RecipeModel recipe;
  final bool? userNewRecipe;
  final String? imageUrl;

  void addIngredientsData(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditIngredient(
          recipeId: recipe.id,
          ingredient: IngredientsModel(),
          newIngredient: true,
          collection: collection,
        );
      },
    );
  }

  void addMethodData(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditMethod(
          recipeId: recipe.id,
          method: MethodModel(),
          newMethod: true,
          collection: collection,
        );
      },
    );
  }

  void addNutritionalData(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditNutritional(
          recipeId: recipe.id,
          nutritionalValue: NutritionalValueModel(),
          newNutritional: true,
          collection: collection,
        );
      },
    );
  }

  Widget headerOverview(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.timer,
                  color: Theme.of(context).primaryColor,
                ),
                BodyText(text: recipe.duration.toString() + " minuten"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.signal_cellular_alt,
                  color: Theme.of(context).primaryColor,
                ),
                BodyText(
                  text: recipe.difficulty,
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 20),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            direction: Axis.horizontal,
            children: getTagWidgets(context),
          ),
        )
      ],
    );
  }

  List<Widget> getTagWidgets(context) {
    List<Widget> widgetList = [];

    for (var i = 0; i < recipe.tags!.length; i++) {
      widgetList.add(
        Container(
          margin: const EdgeInsets.only(top: 2.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: ColorTheme.darkGreen)),
          child: Text(
            recipe.tags![i],
            style: TextStyle(
              color: ColorTheme.grey,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      );
    }
    return widgetList;
  }

  Widget headerFeedback(context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: ColorTheme.lightOrange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntroGreyText(
            text:
                // ignore: lines_longer_than_80_chars
                "Uw recept is helaas niet goedgekeurd door een van onze beheerders. Dit is gedaan volgens de volgende rede: ",
          ),
          SizedBox(
            height: 10,
          ),
          BodyText(
              text:
                  // ignore: lines_longer_than_80_chars
                  recipe.feedback),
          SizedBox(
            height: 10,
          ),
          IntroGreyText(
            text:
                // ignore: lines_longer_than_80_chars
                "Laat dit uw niet ontmoedigen om het nog een keer te proberen! Probeer het recept zo goed mogelijk te verbeteren gebaseerd op de feedback en stuur hem opnieuw in!",
          ),
        ],
      ),
    );
  }

  Widget headerIngredients(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Ingrediënten"),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => addIngredientsData(context),
        )
      ],
    );
  }

  Widget headerMethods(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Methode"),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => addMethodData(context),
        )
      ],
    );
  }

  Widget headerNutritionalValue(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        H2Text(text: "Voedingswaarde per portie"),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => addNutritionalData(context),
        ),
      ],
    );
  }

  Widget headerImage(context) {
    return imageUrl == null
        ? Center(child: CircularProgressIndicator())
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              imageUrl: imageUrl!,
              fit: BoxFit.contain,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: MediaQuery.of(context).size.width < 1300
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                (recipe.feedback == null || recipe.feedback!.isEmpty)
                    ? Container()
                    : headerFeedback(context),
                (recipe.feedback == null || recipe.feedback!.isEmpty)
                    ? Container()
                    : SizedBox(
                        height: 50,
                        child: Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                      ),
                headerOverview(context),
                SizedBox(
                  height: 50,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                headerIngredients(context),
                InheritedDataProvider(
                  data: user!,
                  child: IngredientsStream(
                    recipeId: recipe.id,
                    userNewRecipe: userNewRecipe,
                    collection: collection,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                headerMethods(context),
                InheritedDataProvider(
                  data: user!,
                  child: MethodStream(
                    recipeId: recipe.id,
                    userNewRecipe: userNewRecipe,
                    collection: collection,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                kIsWeb
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: headerImage(context)),
                          SizedBox(width: 50),
                          Expanded(
                            child: Column(
                              children: [
                                headerNutritionalValue(context),
                                InheritedDataProvider(
                                  data: user!,
                                  child: NutrionStream(
                                    recipeId: recipe.id,
                                    userNewRecipe: userNewRecipe,
                                    collection: collection,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headerNutritionalValue(context),
                          InheritedDataProvider(
                            data: user!,
                            child: NutrionStream(
                              recipeId: recipe.id,
                              userNewRecipe: userNewRecipe,
                              collection: collection,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Divider(
                              thickness: 2.0,
                              color: Colors.black,
                            ),
                          ),
                          headerImage(context)
                        ],
                      )
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                headerOverview(context),
                SizedBox(
                  height: 50,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          headerIngredients(context),
                          InheritedDataProvider(
                            data: user!,
                            child: IngredientsStream(
                              recipeId: recipe.id,
                              userNewRecipe: userNewRecipe,
                              collection: collection,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                      child: Column(
                        children: [
                          headerMethods(context),
                          InheritedDataProvider(
                            data: user!,
                            child: MethodStream(
                              recipeId: recipe.id,
                              userNewRecipe: userNewRecipe,
                              collection: collection,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: headerImage(context)),
                    SizedBox(width: 50),
                    Expanded(
                      child: Column(
                        children: [
                          headerNutritionalValue(context),
                          InheritedDataProvider(
                            data: user!,
                            child: NutrionStream(
                              recipeId: recipe.id,
                              userNewRecipe: userNewRecipe,
                              collection: collection,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
