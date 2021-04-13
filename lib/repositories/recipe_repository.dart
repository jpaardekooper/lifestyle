import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/repositories/recipe_repository_interface.dart';
// import 'package:firebase/firebase.dart' as fb;

class RecipeRepository implements IRecipeRepository {
  @override
  Stream<QuerySnapshot> streamAllRecipes() {
    return FirebaseFirestore.instance.collection('recipes').snapshots();
  }

  @override
  List<RecipeModel> getRecipeList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> removeRecipe(String? recipeId, String? url) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .collection('ingredients')
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
        ;
      },
    ).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .collection('method')
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
          ;
        },
      );
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .collection('nutritionalValue')
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
          ;
        },
      );
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .delete()
          .catchError((e) {
        //    print(e);
      }).then((value) => deleteImage(url));
    });
  }

  @override
  Future<void> removeUserRecipe(String? recipeId, String? url) async {
    await FirebaseFirestore.instance
        .collection('createdRecipes')
        .doc(recipeId)
        .collection('ingredients')
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
        ;
      },
    ).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('createdRecipes')
          .doc(recipeId)
          .collection('method')
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
          ;
        },
      );
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('createdRecipes')
          .doc(recipeId)
          .collection('nutritionalValue')
          .get()
          .then(
        (snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
          ;
        },
      );
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("createdRecipes")
          .doc(recipeId)
          .delete()
          .catchError((e) {
        //    print(e);
      }).then((value) => deleteImage(url));
    });
  }

  @override
  Future<void> updateUserRecipe(
      String? recipeId, Map data, bool newRecipe) async {
    if (newRecipe) {
      await FirebaseFirestore.instance
          .collection("createdRecipes")
          .doc(recipeId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("createdRecipes")
          .doc(recipeId)
          .update(data as Map<String, dynamic>)
          .catchError((e) {
        //    print(e);
      });
    }
  }

  @override
  Future<void> updateRecipe(String? recipeId, Map data, bool newRecipe) async {
    if (newRecipe) {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .set(data as Map<String, dynamic>)
          .catchError((e) {
        //    print(e);
      });
    } else {
      await FirebaseFirestore.instance
          .collection("recipes")
          .doc(recipeId)
          .update(data as Map<String, dynamic>)
          .catchError((e) {
        //    print(e);
      });
    }
  }

  @override
  Future<List<RecipeModel>> getRecipeListOnce() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('published', isEqualTo: true)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<RecipeModel>> getSubmittedRecipeListOnce() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('createdRecipes')
        .where('submitted', isEqualTo: true)
        .get();

    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamUserRecipes(String? userId) {
    return FirebaseFirestore.instance
        .collection('createdRecipes')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  List<RecipeModel> getUserRecipeList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return RecipeModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<List<RecipeModel>> getUserFavoriteRecipe(String? userId) async {
    List<RecipeModel> returnList = [];
    List<dynamic> favRecipeList = [];
    int recipeId;

    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    var recipes = await FirebaseFirestore.instance.collection('recipes').get();

    favRecipeList = List.from(snapshot.data()!['favorite_recipes']);

    for (var ids in favRecipeList) {
      recipeId = recipes.docs.indexWhere((element) => element.id == ids);
      if (recipeId != -1) {
        returnList.add(
          RecipeModel.fromSnapshot(recipes.docs[recipeId]),
        );
      }
    }
    return returnList;
  }

  @override
  Future<bool> checkFavoriteRecipe(String? recipeId, String? userId) async {
    List<dynamic> favRecipeList = [];
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    favRecipeList = List.from(snapshot.data()!['favorite_recipes']);

    for (var ids in favRecipeList) {
      if (ids == recipeId) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> addFavoriteRecipe(String? userId, String? recipeId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorite_recipes': FieldValue.arrayUnion([recipeId]),
    });
  }

  @override
  Future<void> removeFavoriteRecipe(String? userId, String? recipeId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorite_recipes': FieldValue.arrayRemove([recipeId]),
    });
  }

  @override
  Future<void> uploadImage(File? img, String? oldImg) async {
    if (img != null) {
      String fileName = basename(img.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('recipeImages/$fileName');
      UploadTask uploadTask = storageRef.putFile(img);
      TaskSnapshot taskSnapshot = await uploadTask;
      await taskSnapshot.ref.getDownloadURL();

      if (oldImg != null) await deleteImage(oldImg);
    }
  }

  @override
  Future<String> getImage(String? image) async {
    String imageUrl = await FirebaseStorage.instance
        .ref()
        .child('recipeImages/$image')
        .getDownloadURL();

    return imageUrl;
  }

  Future<void> deleteImage(String? image) async {
    if (image != "placeholder.png") {
      await FirebaseStorage.instance
          .ref()
          .child('recipeImages/$image')
          .delete();
    }
  }
}
