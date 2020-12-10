import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_explore_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_feed_tabview.dart';
import 'package:lifestylescreening/views/user/recipe/recipe_saved_tabview.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class RecipeTab extends StatefulWidget {
  RecipeTab({Key key}) : super(key: key);

  @override
  _RecipeTabState createState() => _RecipeTabState();
}

class _RecipeTabState extends State<RecipeTab> {
  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Recepten'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Feed'),
                Tab(icon: Icon(Icons.add)),
                Tab(text: 'Favorieten'),
              ],
            ),
          ),
          body: InheritedDataProvider(
            data: _userData.data,
            child: TabBarView(
              children: [
                RecipeFeedView(),
                RecipeExploreView(),
                RecipeFavoritesView(userId: _userData.data.id),
              ],
            ),
          )),
    );
  }
}
