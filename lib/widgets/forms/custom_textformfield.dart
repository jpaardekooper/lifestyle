import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylescreening/models/answer_model.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    this.keyboardType,
    this.textcontroller,
    this.errorMessage,
    this.validator,
    this.secureText,
    this.passwordChecker,
    this.suffixText,
    this.hintText,
    this.function,
    this.answerModel,
    this.border,
  });

  final TextInputType keyboardType;
  final TextEditingController textcontroller;
  final String errorMessage;
  final int validator;
  final bool secureText;
  final String passwordChecker;
  final String suffixText;
  final String hintText;
  final Function(AnswerModel, String) function;
  final AnswerModel answerModel;
  final bool border;

  inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      suffixIcon: suffixText == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                suffixText ?? "",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
      hintText: hintText ?? "",
      contentPadding: const EdgeInsets.all(8),
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2.0,
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        obscureText: secureText ?? false,
        textInputAction: TextInputAction.next,
        controller: textcontroller,
        keyboardType: keyboardType,
        maxLines: secureText ? 1 : 5,
        minLines: 1,
        autofocus: false,
        decoration: (border ?? true)
            ? inputDecoration(context)
            : InputDecoration(border: InputBorder.none, hintText: hintText),
        //return value if theres an value otherwise reutrn error
        // mssge
        validator: (val) {
          //add answer to list

          switch (validator) {
            case 1:
              return val.isEmpty ? errorMessage : null;
              break;
            case 2:
              return validateEmail(val)
                  ? null
                  : errorMessage ?? "gebruik een geldige email";
              break;
            case 3:
              return val != passwordChecker
                  ? "wachtwoord komt niet overeen"
                  : null;
              break;
            case 4:
              return val.isEmpty
                  ? textcontroller.text = "/placeholder.png"
                  : null;
              break;
            case 5:
              return null;
              break;
            case 6:
              if (double.tryParse(val) != null) {
                return null;
              } else {
                return 'Vul een geldig getal in';
              }
              break;
            //this is only for answer screening
            case 7:
              if (double.tryParse(val) != null) {
                function(answerModel, val);
                return null;
              } else {
                return 'Vul een geldig getal in';
              }
              break;
            case 8:
              if (val.isNotEmpty) {
                function(answerModel, val);
              }

              return val.isEmpty ? errorMessage : null;
              break;
            default:
              return val.isEmpty ? errorMessage : null;
          }
        },
      ),
    );
  }
}
