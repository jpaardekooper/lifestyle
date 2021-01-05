import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/category_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/widgets/dialog/remove_category.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'dart:math' as math;

class EditCategoryDialog extends StatefulWidget {
  EditCategoryDialog({this.categoryModel, this.newItem});
  final CategoryModel categoryModel;
  final bool newItem;

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryController _categoryController = CategoryController();

  TextEditingController _catController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _catController.text = widget.categoryModel.category ?? "";
  }

  void _removeCategory() {
    showDialog<RemoveCategory>(
      context: context,
      builder: (BuildContext context) {
        return RemoveCategory(
          category: widget.categoryModel,
        );
      },
    ).then((value) => Navigator.pop(context));
  }

  Widget showTitle(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.name,
            textcontroller: _catController,
            errorMessage: "Geen geldige titel",
            validator: 1,
            secureText: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newItem
          ? Text("Nieuwe survey")
          : Text(
              "ID: ${widget.categoryModel.id}",
              style: TextStyle(fontSize: 11),
            ),
      content: Container(
        width: math.min(MediaQuery.of(context).size.width, 1200),
        height: math.min(MediaQuery.of(context).size.height, 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Naam van de categorie:",
                ),
                showTitle(context),
                SizedBox(
                  height: 25,
                ),
                widget.newItem
                    ? Container()
                    : Center(
                        child: RaisedButton(
                            child: Text('Verwijderen'),
                            onPressed: () => _removeCategory()),
                      )
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        RaisedButton(
            child: Text('Opslaan'),
            onPressed: () => saveCategoryChanges(context))
      ],
    );
  }

  void saveCategoryChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "category": _catController.text,
        "questionCount": widget.categoryModel.questionCount ?? 0,
      };

      _categoryController
          .updateCategory(widget.categoryModel.id, data, widget.newItem)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _catController.dispose();
  }
}
