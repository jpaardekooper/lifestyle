import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/recipe/new_user_recipe.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_feed_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_saved_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_search.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_user_recipes.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key? key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? active;

  @override
  void initState() {
    active = 0;
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          active = _tabController.index;
        });
      });
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Recepten'),
        actions: [
          active == 0
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: RecipeSearch(user: _userData.data));
                  })
              : Container(),
        ],
        bottom: TabBar(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(text: 'Overzicht'),
            Tab(text: 'Eigen recepten'),
            Tab(text: 'Favorieten'),
          ],
        ),
      ),
      floatingActionButton: active == 1
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: "Recept toevoegen",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NewUserRecipeView(user: _userData))),
            )
          : null,
      body: InheritedDataProvider(
        data: _userData.data,
        child: TabBarView(
          children: [
            RecipeFeedView(),
            RecipeUserRecipes(user: _userData.data),
            RecipeFavoritesView(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
