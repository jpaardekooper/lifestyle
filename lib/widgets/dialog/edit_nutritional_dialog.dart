import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';

class EditNutritional extends StatefulWidget {
  EditNutritional({
    @required this.recipeId,
    @required this.nutritionalValue,
    this.newNutritional,
  });
  final String recipeId;
  final NutritionalValueModel nutritionalValue;
  final bool newNutritional;

  @override
  _EditNutritionalState createState() => _EditNutritionalState();
}

class _EditNutritionalState extends State<EditNutritional> {
  final _formKey = GlobalKey<FormState>();
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.nutritionalValue.name ?? "";
    _amountController.text = widget.nutritionalValue.amount ?? "";
    _unitController.text = widget.nutritionalValue.unit ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newNutritional
          ? Text("Voeg een ingrediënt toe")
          : Text(
              "ID: ${widget.nutritionalValue.name}",
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
              Text("naam van het product:"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _nameController,
                errorMessage: "Geen geldige product naamt",
                validator: 1,
                secureText: false,
              ),
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
              Text("type unit (gram, ml, etc..)"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _unitController,
                errorMessage: "Geen geldige unit",
                validator: 1,
                secureText: false,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Annuleren'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => saveIngredientChanges(context),
        )
      ],
    );
  }

  void saveIngredientChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Map<String, String> data = {
        "amount": _amountController.text,
        "name": _nameController.text,
        "unit": _unitController.text,
      };

      _foodPreparationController
          .updateNutritrionalValue(
            widget.recipeId,
            widget.nutritionalValue.id,
            data,
            widget.newNutritional,
          )
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    _nameController.dispose();
    _unitController.dispose();
  }
}
