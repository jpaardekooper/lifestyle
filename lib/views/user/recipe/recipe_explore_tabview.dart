import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class RecipeExploreView extends StatefulWidget {
  RecipeExploreView({this.user});

  final user;

  @override
  _RecipeExploreViewState createState() => _RecipeExploreViewState();
}

class _RecipeExploreViewState extends State<RecipeExploreView> {
  final RecipeController _recipeController = RecipeController();
  TextEditingController _recipenameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _difficultyController = TextEditingController();

  File _imageFile;

  final _picker = ImagePicker();

  RecipeModel recipe = RecipeModel();

  final _formKey = GlobalKey<FormState>();

  Future checkCameraPermission() async {
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future checkStoragePermission() async {
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _recipenameController.dispose();
    _urlController.dispose();
    _durationController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  Widget showRecipeName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: "Naam van het recept:"),
        CustomTextFormField(
          keyboardType: TextInputType.name,
          textcontroller: _recipenameController,
          errorMessage: "Geen geldige recept",
          validator: 1,
          secureText: false,
        ),
      ],
    );
  }

  Widget showRecipeUrl(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BodyText(text: "Foto:"),
        SizedBox(
          width: 20,
        ),
        _imageFile != null
            ? SizedBox(
                height: 200,
                width: 175,
                child: FittedBox(
                    fit: BoxFit.contain, child: Image.file(_imageFile)))
            : RaisedButton(
                child: Text(
                  "Kies een foto",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: BodyText(
                        text: "Kies een bron:",
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                              child: Text("Camera"),
                              onPressed: () {
                                checkCameraPermission();
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                            child: Text("Gallerij"),
                            onPressed: () {
                              checkStoragePermission();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }

  Widget showRecipeDifficulty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: "Moeilijkheidsgraad"),
        CustomTextFormField(
          keyboardType: TextInputType.name,
          textcontroller: _difficultyController,
          hintText: "Moeilijk, Middel, Makkelijk",
          validator: 1,
          secureText: false,
        ),
      ],
    );
  }

  Widget showRecipeDuration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: "Bereidingswijze in minuten:"),
        CustomTextFormField(
          keyboardType: TextInputType.number,
          textcontroller: _durationController,
          errorMessage: "Geen geldig getal",
          validator: 6,
          secureText: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Nieuw recept toevoegen")),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showRecipeName(context),
                  SizedBox(height: 25),
                  showRecipeUrl(context),
                  SizedBox(height: 25),
                  showRecipeDuration(context),
                  SizedBox(height: 25),
                  showRecipeDifficulty(context),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConfirmOrangeButton(
                        text: 'Opslaan',
                        onTap: () => saveRecipeChanges(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  saveRecipeChanges(context) {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "title": _recipenameController.text,
        "url": basename(_imageFile.path),
        "duration": int.parse(_durationController.text),
        "difficulty": _difficultyController.text,
        "published": false,
        "userId": widget.user.data.id,
        "role": widget.user.data.role
      };

      _recipeController.uploadImage(_imageFile).then((value) =>
          _recipeController
              .updateUserRecipe(recipe.id, data, true)
              .then((value) => Navigator.of(context).pop()));
    }
  }
}
