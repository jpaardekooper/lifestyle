import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_method_dialog.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

import '../text/body_text.dart';

// ignore: must_be_immutable
class MethodStream extends StatelessWidget {
  MethodStream({@required this.recipeId, this.userNewRecipe});
  final String recipeId;
  final bool userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  List<MethodModel> _methodList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _foodPreparationController.streamMethod(recipeId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Text("Geen werkwijze gevonden");
        } else {
          _methodList = _foodPreparationController.fetchMethod(snapshot);

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _methodList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              MethodModel _metod = _methodList[index];
              return MethodCard(
                recipeId: recipeId,
                method: _metod,
                userNewRecipe: userNewRecipe,
              );
            },
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class MethodCard extends StatelessWidget {
  MethodCard(
      {@required this.recipeId, @required this.method, this.userNewRecipe});
  final String recipeId;
  final MethodModel method;
  final bool userNewRecipe;
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();

  void onTapEdit(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditMethod(
          recipeId: recipeId,
          method: method,
          newMethod: false,
        );
      },
    );
  }

  void onTapDelete(BuildContext context) {
    _foodPreparationController.removeMethod(recipeId, method.id);
  }

  String role;

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    role = _userData.data.role;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(
            text: method.step.toString() + ".",
            // style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: BodyText(
              text: method.instruction,
            ),
          ),
          role == 'user' && userNewRecipe == false
              ? Container()
              : Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        onTapEdit(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () {
                        onTapDelete(context);
                      },
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
