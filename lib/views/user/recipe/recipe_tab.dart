import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_explore_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_feed_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_saved_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_user_recipes.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key? key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? active;

  @override
  void initState() {
    active = 0;
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          active = _tabController!.index;
        });
      });
    super.initState();
  }

  void dispose() {
    _tabController!.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(text: 'Feed'),
            Tab(icon: Icon(Icons.add)),
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
                          RecipeExploreView(user: _userData))),
            )
          : null,
      body: InheritedDataProvider(
        data: _userData.data,
        child: TabBarView(
          children: [
            RecipeFeedView(),
            RecipeUserRecipes(),
            RecipeFavoritesView(userId: _userData.data.id),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
