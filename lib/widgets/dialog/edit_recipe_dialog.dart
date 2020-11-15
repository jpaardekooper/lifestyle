import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/models/recipe_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';

class EditRecipe extends StatefulWidget {
  EditRecipe({@required this.recipe, @required this.isNewRecipe});

  final RecipeModel recipe;
  final bool isNewRecipe;

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _recipenameController.text = widget.recipe.title ?? "";
    _urlController.text = widget.recipe.url ??
        "https://www.signfix.com.au/wp-content/uploads/2017/09/placeholder-600x400-300x200.png";
    _durationController.text = (widget.recipe.duration ?? "0").toString();
    _difficultyController.text = widget.recipe.difficulty ?? "";
    _published = widget.recipe.published ?? false;

    super.initState();
  }

  Widget showRecipeName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Naam van het recept"),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("URL"),
        CustomTextFormField(
          keyboardType: TextInputType.name,
          textcontroller: _urlController,
          errorMessage: "Geen geldige URL",
          validator: 4,
          secureText: false,
        ),
      ],
    );
  }

  Widget showRecipeDifficulty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Moeilijkheidsgraag"),
        CustomTextFormField(
          keyboardType: TextInputType.name,
          textcontroller: _difficultyController,
          errorMessage: "Geen geldige url",
          validator: 4,
          secureText: false,
        ),
      ],
    );
  }

  Widget showRecipeDuration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bereidingswijze in minuten:"),
        CustomTextFormField(
          keyboardType: TextInputType.number,
          textcontroller: _durationController,
          errorMessage: "Geen geldig getal",
          validator: 4,
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
          ? Text("Nieuwe survey")
          : Text(
              "ID: ${widget.recipe.id}",
              style: TextStyle(fontSize: 11),
            ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              isRecipePublished(context),
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
          onPressed: () => saveRecipeChanges(),
        )
      ],
    );
  }

  void saveRecipeChanges() {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "title": _recipenameController.text,
        "url": _urlController.text,
        "duration": int.parse(_durationController.text),
        "difficulty": _difficultyController.text,
        "published": _published
      };
      _recipeController
          .updateRecipe(widget.recipe.id, data, widget.isNewRecipe)
          .then((value) => Navigator.pop(context));
    }
  }
}
