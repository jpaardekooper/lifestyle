import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/recipe_controller.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class FeedbackRecipe extends StatefulWidget {
  FeedbackRecipe({
    required this.recipeId,
  });
  final String? recipeId;

  @override
  _FeedbackRecipeState createState() => _FeedbackRecipeState();
}

class _FeedbackRecipeState extends State<FeedbackRecipe> {
  final _formKey = GlobalKey<FormState>();
  final RecipeController _recipeController = RecipeController();
  TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: H1Text(text: "Recept afkeuren"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text("Geef een redenering voor het afkeuren van dit recept:"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _feedbackController,
                errorMessage: "Geen geldige redenering",
                validator: 1,
                secureText: false,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: IntroGreyText(
            text: 'Cancel',
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: Text(
            'Afkeuren',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () {
            saveFeedback(context);
          },
        )
      ],
    );
  }

  void saveFeedback(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "submitted": false,
        "feedback": _feedbackController.text,
      };

      _recipeController
          .updateUserRecipe(widget.recipeId, data, false)
          .then((value) => Navigator.of(context).pop(true));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _feedbackController.dispose();
  }
}
