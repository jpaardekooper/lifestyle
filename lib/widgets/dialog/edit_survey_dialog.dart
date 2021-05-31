import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/survey_controller.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/cards/select_category.dart';
import 'dart:math' as math;

import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class EditSurveyView extends StatefulWidget {
  const EditSurveyView({this.surveyInfo, this.newItem});
  final SurveyModel? surveyInfo;
  final bool? newItem;

  @override
  _EditSurveyViewState createState() => _EditSurveyViewState();
}

class _EditSurveyViewState extends State<EditSurveyView> {
  final SurveyController _surveyController = SurveyController();
  TextEditingController _surveyNameController = TextEditingController();
  List<String> reorderCategoryList = [];

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    reorderCategoryList = widget.surveyInfo!.category ?? [];
    _surveyNameController.text = widget.surveyInfo!.title ?? "";
  }

  Widget showTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(
          text: "Titel:",
        ),
        CustomTextFormField(
          keyboardType: TextInputType.name,
          textcontroller: _surveyNameController,
          errorMessage: "Geen geldige titel",
          validator: 1,
          secureText: false,
        ),
      ],
    );
  }

  String _selectedCategory = "";
  set string(String value) => setState(() => _selectedCategory = value);

  Widget showCategoriesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H2Text(
          text: "Voeg een categorie toe:",
        ),
        SelectCategory(
          selectedCategory: _selectedCategory,
          callBack: (val) => setState(() => _selectedCategory = val!),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(_selectedCategory)),
            reorderCategoryList.contains(_selectedCategory) ||
                    _selectedCategory.isEmpty
                ? Container()
                : RawMaterialButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        if (!reorderCategoryList.contains(_selectedCategory)) {
                          reorderCategoryList.add(_selectedCategory);
                        }
                        FocusScope.of(context).unfocus();
                      });
                    },
                    constraints: const BoxConstraints(
                      minWidth: 35.0,
                      minHeight: 35.0,
                    ),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                  ),
          ],
        ),
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      String game = reorderCategoryList[oldIndex];

      reorderCategoryList.removeAt(oldIndex);
      reorderCategoryList.insert(newIndex, game);
    });
  }

  List<ListTile> getListItems() => reorderCategoryList
      .asMap()
      .map((i, item) => MapEntry(i, buildTenableListTile(item, i)))
      .values
      .toList();

  ListTile buildTenableListTile(String item, int index) {
    return ListTile(
      tileColor: ColorTheme.extraLightOrange,
      key: ValueKey(item),
      title: Text(item),
      leading: Text("#${index + 1}"),
      trailing: InkWell(
        onTap: () {
          if (widget.newItem!) {
            setState(() {
              reorderCategoryList.removeAt(index);
            });
          } else {
            _surveyController.removeCategory(widget.surveyInfo!.id, item);

            setState(() {
              reorderCategoryList.removeAt(index);
            });
          }
        },
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget showCategories() {
    return Container(
      height: 300,
      child: ReorderableListView(
        header: Row(
          children: [
            Icon(Icons.info),
            Expanded(
              child: Text(
                "Hou de categorie ingedrukt om de volgorde te wijzigen",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        onReorder: onReorder,
        children: getListItems(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newItem!
          ? Text("Nieuwe survey")
          : Text(
              "ID: ${widget.surveyInfo!.id}",
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
                showTitle(context),
                SizedBox(
                  height: 25,
                ),
                showCategoriesList(context),
                SizedBox(
                  height: 25,
                ),
                showCategories(),
              ],
            ),
          ),
        ),
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
              'Opslaan',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.020,
              ),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor),
            onPressed: () => saveSurveyChanges(context))
      ],
    );
  }

  void saveSurveyChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "title": _surveyNameController.text,
        "category": reorderCategoryList,
      };

      _surveyController
          .updateSurvey(widget.surveyInfo!.id, data, widget.newItem)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _surveyNameController.dispose();
  }
}
