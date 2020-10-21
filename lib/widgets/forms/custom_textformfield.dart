import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {this.keyboardType,
      this.textcontroller,
      this.errorMessage,
      this.validator,
      this.secureText,
      this.passwordChecker});

  final TextInputType keyboardType;
  final TextEditingController textcontroller;
  final String errorMessage;
  final int validator;
  final bool secureText;
  final String passwordChecker;

  inputDecoration() {
    return InputDecoration(
      filled: true,
      //  isDense: true,
      contentPadding: EdgeInsets.all(12),
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.white,
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
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        obscureText: secureText,
        textInputAction: TextInputAction.next,
        controller: textcontroller,
        keyboardType: keyboardType,
        //return value if theres an value otherwise reutrn error
        // mssge
        validator: (val) {
          switch (validator) {
            case 1:
              return val.isEmpty ? errorMessage : null;
              break;
            case 2:
              return validateEmail(val) ? null : "Enter correct email";
              break;
            case 3:
              return val != passwordChecker
                  ? "wachtwoord komt niet overeen"
                  : null;
              break;
            default:
          }
          return val.isEmpty ? errorMessage : null;
        },
        decoration: inputDecoration(),
      ),
    );
  }
}
