import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/category_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';

import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class RemoveCategory extends StatelessWidget {
  RemoveCategory({this.category});
  final CategoryModel? category;

  final CategoryController _surveyController = CategoryController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Waarschuwing",
        style: TextStyle(color: ColorTheme.orange),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H2Text(text: "Category: " + category!.category!),
          SizedBox(
            height: 10,
          ),
          Text("id: " + category!.id!),
          SizedBox(
            height: 10,
          ),
          Text(
            "Druk op opslaan om door te gaan met verwijderen ",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: IntroGreyText(
            text: 'Annuleren',
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: Text(
            'Verwijderen',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () => _surveyController
              .removeCategory(category!.id)
              .then((value) => Navigator.pop(context)),
        )
      ],
    );
  }
}
