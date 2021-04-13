import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/ingredients_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class EditIngredient extends StatefulWidget {
  EditIngredient(
      {required this.recipeId,
      required this.ingredient,
      this.newIngredient,
      this.collection});
  final String? recipeId;
  final IngredientsModel ingredient;
  final bool? newIngredient;
  final String? collection;

  @override
  _EditIngredientState createState() => _EditIngredientState();
}

class _EditIngredientState extends State<EditIngredient> {
  final _formKey = GlobalKey<FormState>();
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _amountController.text = widget.ingredient.amount ?? "";
    _productController.text = widget.ingredient.product ?? "";
    _unitController.text = widget.ingredient.unit ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newIngredient!
          ? Text("Voeg een ingrediënt toe")
          : Text(
              "ID: ${widget.ingredient.product}",
              style: TextStyle(fontSize: 11),
            ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text("Hoeveelheid in getallen "),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _amountController,
                errorMessage: "Geen geldige recept getal",
                validator: 1,
                secureText: false,
              ),
              SizedBox(
                height: 25,
              ),
              Text("Type unit (gram etc..)"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _unitController,
                errorMessage: "Geen geldige unit",
                validator: 1,
                secureText: false,
              ),
              SizedBox(
                height: 25,
              ),
              Text("Naam van het product:"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _productController,
                errorMessage: "Geen geldige product naam",
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
              onPressed: () => Navigator.of(context).pop(),
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
          onPressed: () => saveIngredientChanges(context),
        )
      ],
    );
  }

  void saveIngredientChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Map<String, String> data = {
        "amount": _amountController.text,
        "product": _productController.text,
        "unit": _unitController.text,
      };

      _foodPreparationController
          .updateIngredient(widget.recipeId, widget.ingredient.id, data,
              widget.newIngredient, widget.collection)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _productController.dispose();
    _unitController.dispose();
  }
}
