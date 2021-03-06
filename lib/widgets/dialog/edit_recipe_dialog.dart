import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/controllers/tags_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/models/tags_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/remove_recipe.dialog.dart';
import 'package:lifestylescreening/widgets/forms/custom_answerfield.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h3_orange_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class EditRecipe extends StatefulWidget {
  EditRecipe({required this.recipe, required this.isNewRecipe, this.user});

  final RecipeModel recipe;
  final bool isNewRecipe;
  final AppUser? user;

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  final RecipeController _recipeController = RecipeController();
  final TagsController _tagsController = TagsController();

  TextEditingController _recipenameController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _difficultyController = TextEditingController();
  TextEditingController _portionController = TextEditingController();
  bool? _published;

  List<String> _locations = ['Moeilijk', 'Middel', 'Makkelijk']; // Option 2
  String? _selectedLocation;

  List<TagsModel> _tags = [];
  List<String>? _selectedTags;

  final _formKey = GlobalKey<FormState>();
  File? _imageFile;

  @override
  void initState() {
    _recipenameController.text = widget.recipe.title ?? "";
    _urlController.text = widget.recipe.url ?? "placeholder.png";
    _durationController.text = (widget.recipe.duration ?? "0").toString();
    _difficultyController.text = widget.recipe.difficulty ?? "";
    _portionController.text = (widget.recipe.portion ?? "0").toString();
    _published = widget.recipe.published ?? false;
    _selectedLocation = _difficultyController.text.isEmpty
        ? _locations[0]
        : _difficultyController.text;

    _selectedTags = widget.recipe.tags ?? [];

    super.initState();
  }

  final _picker = ImagePicker();

  Future checkCameraPermission() async {
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future checkStoragePermission() async {
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
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
                    fit: BoxFit.contain, child: Image.file(_imageFile!)))
            : OutlinedButton(
                child: Text(
                  "Kies een foto",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: () => showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: BodyText(
                        text: "Kies een bron:",
                      ),
                      actions: [
                        TextButton(
                            child: H3OrangeText(text: "Camera"),
                            onPressed: () {
                              checkCameraPermission();
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                          child: H3OrangeText(text: "Galerij"),
                          onPressed: () {
                            checkStoragePermission();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
              )
      ],
    );
  }

  Widget showRecipeDifficulty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: FittedBox(
            fit: BoxFit.contain,
            child: DropdownButton(
              dropdownColor: ColorTheme.extraLightGreen,
              hint: BodyText(text: 'Selecteer de moeilijkheidsgraad'),
              value: _selectedLocation,
              onChanged: (dynamic newValue) {
                setState(() {
                  if (newValue == _locations[0]) {
                    _selectedLocation = _locations[1];
                  } else {
                    _selectedLocation = newValue;
                  }

                  _difficultyController.text = _selectedLocation!;
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

  Widget showRecipePortion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: "Aantal porties:"),
        CustomTextFormField(
          keyboardType: TextInputType.number,
          textcontroller: _portionController,
          errorMessage: "Geen geldig getal",
          validator: 6,
          secureText: false,
        ),
      ],
    );
  }

  void toggle() {
    setState(() {
      _published = !_published!;
    });
  }

  Widget isRecipePublished(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text("Is het gepubliceerd")),
        Switch(
            value: _published!,
            onChanged: (val) {
              toggle();
            }),
      ],
    );
  }

  Widget showRecipeTags(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: "Tags:",
        ),
        SizedBox(
          height: 10,
        ),
        _tags.isEmpty
            ? Container()
            : Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                    color: Colors.black,
                  ),
                  shrinkWrap: true,
                  itemCount: _tags.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      selected: _selectedTags!.contains(_tags[index].tag),
                      onTap: () {
                        if (_selectedTags!.contains(_tags[index].tag!)) {
                          setState(() {
                            _selectedTags!
                                .removeWhere((val) => val == _tags[index].tag!);
                          });
                        } else {
                          setState(() {
                            _selectedTags!.add(_tags[index].tag!);
                          });
                        }
                      },
                      title: Text(_tags[index].tag!),
                      trailing: Icon(
                          _selectedTags!.contains(_tags[index].tag)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _selectedTags!.contains(_tags[index].tag)
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                    );
                  },
                ),
              ),
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
      content: FutureBuilder(
        future: _tagsController.getTagsList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            _tags = snapshot.data;
          }
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    widget.user!.role == "user"
                        ? Container()
                        : isRecipePublished(context),
                    showRecipeName(context),
                    SizedBox(height: 25),
                    showRecipeUrl(context),
                    SizedBox(height: 25),
                    showRecipeDuration(context),
                    SizedBox(height: 25),
                    showRecipePortion(context),
                    SizedBox(height: 25),
                    showRecipeDifficulty(context),
                    SizedBox(height: 25),
                    showRecipeTags(context),
                    widget.isNewRecipe
                        ? Container()
                        : ElevatedButton(
                            child: Text('Recept verwijderen'),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              _removeRecipe(
                                  widget.recipe, widget.user!.role, context);
                            },
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          child: IntroGreyText(
            text: 'Annuleren',
          ),
          onPressed: () => Navigator.pop(context, null),
        ),
        ElevatedButton(
          child: Text(
            'Opslaan',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () {
            saveRecipeChanges(context);
          },
        )
      ],
    );
  }

  void saveRecipeChanges(context) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "title": _recipenameController.text,
        "url": _imageFile == null
            ? _urlController.text
            : basename(_imageFile!.path),
        "duration": int.parse(_durationController.text),
        "difficulty": _difficultyController.text,
        "published": _published,
        "date": widget.isNewRecipe ? DateTime.now() : widget.recipe.date,
        "portion": int.parse(_portionController.text),
        "tags": _selectedTags,
        "userId": widget.user!.id,
      };

      if (widget.user!.role == "user") {
        _recipeController.uploadImage(_imageFile, widget.recipe.url).then(
            (value) => _recipeController
                .updateUserRecipe(widget.recipe.id, data, widget.isNewRecipe)
                .then((value) => Navigator.pop(context)));
      } else {
        _recipeController.uploadImage(_imageFile, widget.recipe.url).then(
            (value) => _recipeController
                .updateRecipe(widget.recipe.id, data, widget.isNewRecipe)
                .then((value) => Navigator.pop(context)));
      }
    }
  }

  void _removeRecipe(RecipeModel recipe, String? role, context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RemoveRecipe(recipe: recipe, role: role);
      },
    ).then((Navigator.of(context).pop));
  }
}
