import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/nutritional_value_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class EditNutritional extends StatefulWidget {
  EditNutritional({
    required this.recipeId,
    required this.nutritionalValue,
    this.newNutritional,
    this.collection,
  });
  final String? recipeId;
  final NutritionalValueModel nutritionalValue;
  final bool? newNutritional;
  final String? collection;

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
    _amountController.text = (widget.nutritionalValue.amount ?? "").toString();
    _unitController.text = widget.nutritionalValue.unit ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newNutritional!
          ? Text("Voeg een voedingswaarde toe")
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
              Text("Naam van de voedingswaarde:"),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                textcontroller: _nameController,
                errorMessage: "Geen geldige product naam",
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
                errorMessage: "Geen geldig recept getal",
                validator: 6,
                secureText: false,
              ),
              SizedBox(
                height: 25,
              ),
              Text("Type unit (gram, ml, etc..)"),
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
        TextButton(
          child: IntroGreyText(
            text: 'Cancel',
          ),
          onPressed: () => Navigator.pop(context),
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
      Map<String, dynamic> data = {
        "amount": double.parse(_amountController.text),
        "name": _nameController.text,
        "unit": _unitController.text,
      };

      _foodPreparationController
          .updateNutritrionalValue(
            widget.recipeId,
            widget.nutritionalValue.id,
            data,
            widget.newNutritional,
            widget.collection,
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
