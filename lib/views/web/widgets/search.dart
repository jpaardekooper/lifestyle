import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/views/web/utils/responsive_layout.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';

class Search extends StatelessWidget {
  Search({@required this.function});
  final Function(BuildContext) function;

  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 4.0,
        //    right: ResponsiveLayout.isSmallScreen(context) ? 4 : 74,
        top: 10,
        bottom: 40,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 8), blurRadius: 8)
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Form(
                  key: _formKey,
                  child: CustomTextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textcontroller: controller,
                      errorMessage: "Gebruik een geldige e-mail adres",
                      validator: 2,
                      secureText: false,
                      border: false,
                      hintText: 'Vul uw email adres in voor de nieuwsbrief'),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              ColorTheme.accentOrange,
                              ColorTheme.orange
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> data = {
                              "email": controller.text,
                              "date": DateTime.now(),
                            };

                            await AuthController()
                                .subscribeToLifestyle(data)
                                .then((value) {
                              function(context);
                              controller.text = "";
                            });
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ResponsiveLayout.isSmallScreen(context)
                                  ? Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          "Aboneren",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(width: 5),
                              ResponsiveLayout.isSmallScreen(context)
                                  ? Container()
                                  : Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
