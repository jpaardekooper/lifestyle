import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/category_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/views/admin/categories/question_view.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_category_dialog.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class CategoriesView extends StatefulWidget {
  CategoriesView({Key key}) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoryController _surveyController = CategoryController();

  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<CategoryModel> _categoryList = [];

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        _surveyController.streamCategories().listen(_updateSurveyList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _categoryList.clear();
  }

  void _updateSurveyList(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _categoryList = _surveyController.fetchCategories(snapshot);
    });
  }

  void _editSurveyName(CategoryModel category) {
    showDialog<EditCategoryDialog>(
        context: context,
        builder: (BuildContext context) {
          return EditCategoryDialog(
            categoryModel: category,
            newItem: false,
          );
        });
  }

  void _addSurvey(BuildContext context) {
    showDialog<EditCategoryDialog>(
      context: context,
      builder: (BuildContext context) {
        return EditCategoryDialog(
          categoryModel: CategoryModel(),
          newItem: true,
        );
      },
    );
  }

  Widget showCategories() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _categoryList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 2,
        //  childAspectRatio: (itemWidth / itemHeight),
      ),
      itemBuilder: (BuildContext ctxt, int index) {
        CategoryModel _category = _categoryList[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: ColorTheme.extraLightOrange,
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuestionView(
                    categoryModel: _category,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RawMaterialButton(
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _editSurveyName(_category);
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: H2Text(text: _category.category),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        "Aantal vragen:  ${_category.questionCount ?? ""}"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1280),
          child: _isLoading
              ? CircularProgressIndicator()
              : _categoryList.isNotEmpty
                  ? showCategories()
                  : Center(
                      child: Text('Geen categorieEn gevonden'),
                      //onPressed: _onAddRandomRecipesPressed,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSurvey(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
