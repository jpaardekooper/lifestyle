import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/repositories/recipe_repository_interface.dart';

class RecipeRepository implements IRecipeRepository {
  @override
  Stream<QuerySnapshot> streamAllRecipes() {
    return FirebaseFirestore.instance
        .collection('recipes')
        // .where('published', isEqualTo: 1)
        .snapshots();
  }

  @override
  List<RecipeModel> getRecipeList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> removeRecipe(String recipeId) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .delete()
        .catchError((e) {
      //    print(e);
    });
  }

  @override
  Future<void> updateRecipe(String recipeId, Map data, bool newRecipe) async {
    if (newRecipe) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc()
          .set(data)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .set(data)
          .catchError((e) {
        //    print(e);
      });
    }
  }

  @override
  Future<List<RecipeModel>> getRecipeListOnce() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        // .where('published', isEqualTo: 1)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }
}
