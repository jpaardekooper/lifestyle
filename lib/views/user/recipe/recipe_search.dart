import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/controllers/tags_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/models/tags_model.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_grid.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class RecipeSearch extends SearchDelegate<String> {
  final AppUser user;

  RecipeSearch({required this.user});

  RecipeController _recipeController = RecipeController();
  TagsController _tagsController = TagsController();

  List<RecipeModel> _filteredList = [];
  List<RecipeModel> _recipeList = [];
  List<TagsModel> _tagsList = [];

  int? index;

  getValues() async {
    _recipeList = await _recipeController.getRecipeListOnce();
    _tagsList = await _tagsController.getTagsList();
  }

  filterRecipes() {
    if (index == null) {
      if (query.isNotEmpty) {
        _filteredList = _recipeList.reversed
            .where((element) => element.title!
                .toLowerCase()
                .startsWith(query.toLowerCase().trim()))
            .toList();
      } else {
        _filteredList = _recipeList;
      }
    } else {
      if (query.isEmpty) {
        _filteredList = _recipeList.reversed
            .where((element) => element.tags!.contains(_tagsList[index!].tag!))
            .toList();
      } else {
        _filteredList = _recipeList.reversed
            .where((element) => element.tags!.contains(_tagsList[index!].tag!))
            .toList();
        _filteredList = _filteredList.reversed
            .where((element) => element.title!
                .toLowerCase()
                .startsWith(query.toLowerCase().trim()))
            .toList();
      }
    }
  }

  List<Widget> getTagWidgets(BuildContext context, setState) {
    List<Widget> widgetList = [];

    for (var i = 0; i < _tagsList.length; i++) {
      widgetList.add(
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: index == i ? Theme.of(context).primaryColor : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            setState(() {
              if (index == i) {
                index = null;
              } else {
                index = i;
              }
            });
          },
          child: Text(
            _tagsList[i].tag!,
            style: TextStyle(
              color: index == i ? Colors.white : ColorTheme.grey,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
      );
    }
    return widgetList;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    getValues();
    return [
      IconButton(
          icon: Icon(
            HealthpointIcons.crossIcon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(
          HealthpointIcons.arrowLeftIcon,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          close(context, '');
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        filterRecipes();
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
                child: Container(
                  color: ColorTheme.extraLightGreen,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: ColorTheme.extraLightGreen,
                child: Wrap(
                  spacing: 5,
                  // runSpacing: 5,
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: getTagWidgets(context, setState),
                ),
              ),
              SizedBox(
                height: 10,
                child: Container(
                  color: ColorTheme.extraLightGreen,
                ),
              ),
              Container(
                color: ColorTheme.extraLightGreen,
                child: Divider(
                  thickness: 1.0,
                  height: 0,
                  // indent: 20,
                  // endIndent: 20,
                  color: ColorTheme.darkGreen,
                ),
              ),
              _filteredList.isNotEmpty
                  ? RecipeGrid(
                      recipeList: _filteredList,
                      userData: user,
                      userRecipe: false,
                      onTap: null,
                    )
                  : Center(
                      child: H1Text(
                        text: "Geen recepten gevonden",
                      ),
                      heightFactor: 10,
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
