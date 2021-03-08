import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/food_preparation_controller.dart';
import 'package:lifestylescreening/models/method_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';

class EditMethod extends StatefulWidget {
  EditMethod({required this.recipeId, required this.method, this.newMethod});
  final String? recipeId;
  final MethodModel method;
  final bool? newMethod;

  @override
  _EditMethodState createState() => _EditMethodState();
}

class _EditMethodState extends State<EditMethod> {
  final _formKey = GlobalKey<FormState>();
  final FoodPreparationController _foodPreparationController =
      FoodPreparationController();
  TextEditingController _stepController = TextEditingController();
  TextEditingController _instructionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _stepController.text = (widget.method.step ?? "").toString();
    _instructionController.text = widget.method.instruction ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.newMethod!
          ? Text("Voeg een stappenplan toe")
          : Text(
              "ID: ${widget.method.id}",
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
              Text("Stappen teller"),
              CustomTextFormField(
                keyboardType: TextInputType.number,
                textcontroller: _stepController,
                errorMessage: "Geen geldige getal",
                validator: 1,
                secureText: false,
              ),
              SizedBox(
                height: 25,
              ),
              Text("Instructie: "),
              CustomTextFormField(
                keyboardType: TextInputType.multiline,
                textcontroller: _instructionController,
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
          onPressed: () => saveSurveyChanges(context),
        )
      ],
    );
  }

  void saveSurveyChanges(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "step": int.parse(_stepController.text),
        "instruction": _instructionController.text,
      };

      _foodPreparationController
          .updateMethod(
              widget.recipeId, widget.method.id, data, widget.newMethod)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stepController.dispose();
    _instructionController.dispose();
  }
}
