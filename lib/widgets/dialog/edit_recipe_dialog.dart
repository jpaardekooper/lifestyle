import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_answerfield.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class EditRecipe extends StatefulWidget {
  EditRecipe({@required this.recipe, @required this.isNewRecipe, this.role});

  final RecipeModel recipe;
  final bool isNewRecipe;
  final String role;

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final RecipeController _recipeController = RecipeController();
  TextEditingController _recipenameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _difficultyController = TextEditingController();
  bool _published;

  List<String> _locations = [
    'Selecteer de moeilijkheidsgraad',
    'Moeilijk',
    'Middel',
    'Makkelijk'
  ]; // Option 2
  String _selectedLocation;

  final _formKey = GlobalKey<FormState>();
  File _imageFile;

  @override
  void initState() {
    _recipenameController.text = widget.recipe.title ?? "";
    _urlController.text = widget.recipe.url ?? "placeholder.png";
    _durationController.text = (widget.recipe.duration ?? "0").toString();
    _difficultyController.text = widget.recipe.difficulty ?? "";
    _published = widget.recipe.published ?? false;
    _selectedLocation = _difficultyController.text.isEmpty
        ? _locations[0]
        : _difficultyController.text;

    super.initState();
  }

  final _picker = ImagePicker();

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
        CustomAnswerFormField(
          keyboardType: TextInputType.name,
          textcontroller: _difficultyController,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButton(
            dropdownColor: ColorTheme.extraLightGreen,
            hint: BodyText(text: 'Selecteer de moeilijkheidsgraad'),
            value: _selectedLocation,
            onChanged: (newValue) {
              setState(() {
                if (newValue == _locations[0]) {
                  _selectedLocation = _locations[1];
                } else {
                  _selectedLocation = newValue;
                }

                _difficultyController.text = _selectedLocation;
              });
            },
            items: _locations.map((location) {
              return DropdownMenuItem(
                child: Text(location),
                value: location,
              );
            }).toList(),
          ),
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

  void toggle() {
    setState(() {
      _published = !_published;
    });
  }

  Widget isRecipePublished(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text("Is het gepubliceerd")),
        Switch(
            value: _published,
            onChanged: (val) {
              toggle();
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.isNewRecipe
          ? Text("Nieuw Recept")
          : Text(
              "ID: ${widget.recipe.id}",
              style: TextStyle(fontSize: 11),
            ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              widget.role == "user" ? Container() : isRecipePublished(context),
              showRecipeName(context),
              SizedBox(height: 25),
              showRecipeUrl(context),
              SizedBox(height: 25),
              showRecipeDuration(context),
              SizedBox(height: 25),
              showRecipeDifficulty(context)
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => saveRecipeChanges(context),
        )
      ],
    );
  }

  void saveRecipeChanges(context) {
    if (_formKey.currentState.validate()) {
      var test;
      if (_imageFile != null) {
        test = basename(_imageFile.path);
      } else {
        test = _urlController.text;
      }
      Map<String, dynamic> data = {
        "title": _recipenameController.text,
        "url": test,
        "duration": int.parse(_durationController.text),
        "difficulty": _difficultyController.text,
        "published": _published,
      };
      if (widget.role == "user") {
        _recipeController
            .updateUserRecipe(widget.recipe.id, data, widget.isNewRecipe)
            .then((value) => Navigator.pop(context));
      } else {
        if (_imageFile != null) {
          _recipeController.uploadImage(_imageFile).then((value) =>
              _recipeController
                  .updateRecipe(widget.recipe.id, data, widget.isNewRecipe)
                  .then((value) => Navigator.pop(context)));
        } else {
          _recipeController
              .updateRecipe(widget.recipe.id, data, widget.isNewRecipe)
              .then((value) => Navigator.pop(context));
        }
      }
    }
  }
}
