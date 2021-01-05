import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
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
  Future<void> removeRecipe(String recipeId, String url) async {
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .delete()
        .catchError((e) {
      //    print(e);
    }).then((value) => deleteImage(url));
  }

  @override
  Future<void> removeUserRecipe(String recipeId, String url) async {
    await FirebaseFirestore.instance
        .collection("createdRecipes")
        .doc(recipeId)
        .delete()
        .catchError((e) {
      //    print(e);
    }).then((value) => deleteImage(url));
  }

  @override
  Future<void> updateUserRecipe(
      String recipeId, Map data, bool newRecipe) async {
    if (newRecipe) {
      await FirebaseFirestore.instance
          .collection("createdRecipes")
          .doc(recipeId)
          .set(data)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("createdRecipes")
          .doc(recipeId)
          .set(data)
          .catchError((e) {
        //    print(e);
      });
    }
  }

  @override
  Future<void> updateRecipe(String recipeId, Map data, bool newRecipe) async {
    if (newRecipe) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
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

  @override
  Future<List<RecipeModel>> getUserRecipes(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('createdRecipes')
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<RecipeModel>> getUserFavoriteRecipe(String userId) async {
    List<RecipeModel> returnList = List<RecipeModel>();
    List<dynamic> favRecipeList = [];
    int recipeId;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .get();

    var recipes = await FirebaseFirestore.instance.collection('recipes').get();

    // if (snapshot.docs[0].exists) {
    snapshot.docs
        .map(
          (e) => favRecipeList = e.data()['id'],
        )
        .toList();

    for (var ids in favRecipeList) {
      recipeId = recipes.docs.indexWhere((element) => element.id == ids);
      if (recipeId != -1) {
        returnList.add(
          RecipeModel.fromSnapshot(recipes.docs[recipeId]),
        );
        // }
      }
    }
    return returnList;
  }

  @override
  Future<bool> checkFavoriteRecipe(String recipeId, String userId) async {
    List<dynamic> favRecipeList = [];
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .get()
        .catchError((e) {});

    snapshot.docs
        .map(
          (e) => favRecipeList = e.data()['id'],
        )
        .toList();

    for (var ids in favRecipeList) {
      if (ids == recipeId) {
        return true;
      }
    }
    return false;
  }

  Future<void> addFavoriteRecipe(String userId, String recipeId) async {
    // var snapshot = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId)
    //     .collection('favoriteRecipes')
    //     .doc('recipe')
    //     .snapshots();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .doc('recipe')
        .update({
      'id': FieldValue.arrayUnion([recipeId]),
    });
  }

  Future<void> removeFavoriteRecipe(String userId, String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteRecipes')
        .doc('recipe')
        .update({
      'id': FieldValue.arrayRemove([recipeId]),
    });
  }

  Future<RecipeModel> getSingleRecipeById(String recipeId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .get();

    return RecipeModel.fromSnapshot(snapshot);
  }

  Future<void> uploadImage(File img) async {
    String fileName = basename(img.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('recipeImages/$fileName');
    UploadTask uploadTask = storageRef.putFile(img);
    TaskSnapshot taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> getImage(String image) async {
    String imageUrl = await FirebaseStorage.instance
        .ref()
        .child('recipeImages/$image')
        .getDownloadURL();

    return imageUrl;
  }

  Future<void> deleteImage(String image) async {
    await FirebaseStorage.instance.ref().child('recipeImages/$image').delete();
  }
}
