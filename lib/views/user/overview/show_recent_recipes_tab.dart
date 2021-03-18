import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/views/user/food_preparation_view.dart';
import 'package:lifestylescreening/widgets/cards/recipe_card.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class ShowRecentRecipesTab extends StatefulWidget {
  ShowRecentRecipesTab({Key? key, this.onTap, this.user}) : super(key: key);
  final VoidCallback? onTap;
  final AppUser? user;
  @override
  _ShowRecentRecipesTabState createState() => _ShowRecentRecipesTabState();
}

class _ShowRecentRecipesTabState extends State<ShowRecentRecipesTab> {
  RecipeController _recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H1Text(
                text: "Laatste recepten",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alles inzien",
                    style: TextStyle(
                        fontSize: size.height * 0.021,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    HealthpointIcons.arrowRightIcon,
                    color: Theme.of(context).accentColor,
                    size: size.height * 0.021,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        FutureBuilder<List<RecipeModel>>(
          future: _recipeController.getRecipeListOnce(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                height: size.height / 3.5,
                child: ListView(
                  shrinkWrap: true,
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: buildRecipeCards(snapshot.data),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  List<Widget> buildRecipeCards(List<RecipeModel> recipes) {
    recipes.sort((a, b) => b.date!.compareTo(a.date!));
    List<Widget> recipeCards = [];
    int lenght;

    if (recipes.length < 3) {
      lenght = recipes.length;
    } else {
      lenght = 3;
    }

    if (recipes.isNotEmpty) {
      for (var i = 0; i < lenght; i++) {
        recipeCards.add(GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InheritedDataProvider(
                data: widget.user!,
                child: FoodPreparationView(
                  recipe: recipes[i],
                  userNewRecipe: false,
                ),
              ),
            ),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: RecipeCard(
                recipe: recipes[i],
                user: widget.user,
                userRecipe: false,
              )),
        ));
      }
    } else {
      recipeCards.add(Center(child: CircularProgressIndicator()));
    }

    return recipeCards;
  }
}
