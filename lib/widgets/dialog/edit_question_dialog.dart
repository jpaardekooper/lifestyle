import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class EditQuestionDialog extends StatefulWidget {
  const EditQuestionDialog({
    required this.category,
    required this.question,
    this.newQuestion,
    this.totalQuestion,
  });
  final CategoryModel category;
  final QuestionModel question;
  final bool? newQuestion;
  final int? totalQuestion;

  @override
  _EditQuestionDialogState createState() => _EditQuestionDialogState();
}

class _EditQuestionDialogState extends State<EditQuestionDialog> {
  //Question: category,example,has_followup,next,order,question,
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();
  TextEditingController orderController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  bool hasImage = false;

  @override
  void initState() {
    super.initState();
    //if its a new question set all parameters to empty
    orderController.text =
        (widget.question.order ?? widget.totalQuestion).toString();
    questionController.text = widget.question.question ?? "";
    imageController.text = widget.question.url ?? "0";
    if (widget.question.url == "0" || widget.question.url == null) {
      hasImage = false;
    } else {
      hasImage = true;
    }

    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
    questionController.dispose();
  }

  Widget showOrder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 3, child: H1Text(text: "Vraag volgorde")),
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: orderController,
            errorMessage: "Geen geldige titel",
            validator: 5,
            secureText: false,
          ),
        )
      ],
    );
  }

  Widget showQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        H1Text(text: "Vraagstelling: "),
        CustomTextFormField(
          keyboardType: TextInputType.multiline,
          textcontroller: questionController,
          errorMessage: "Geen geldige vraag",
          validator: 1,
          secureText: false,
        )
      ],
    );
  }

  Widget showUrl(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 3, child: H1Text(text: "Heeft het een afbeelding?: ")),
            Flexible(
              child: Switch(
                value: hasImage,
                onChanged: (value) {
                  setState(() {
                    hasImage = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
          ],
        ),
        hasImage
            ? CustomTextFormField(
                keyboardType: TextInputType.multiline,
                textcontroller: imageController,
                errorMessage: "Geen geldige url",
                hintText: "https://...",
                validator: 1,
                secureText: false,
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void saveQuestionChanges(BuildContext context) {
    if (!hasImage) {
      imageController.text = "0";
    }
    if (_formKey.currentState!.validate()) {
      // category,example,has_followup,next,order,question,
      Map<String, dynamic> data = {
        "order": int.parse(orderController.text),
        "question": questionController.text,
        "url": imageController.text
      };

      _questionnaireController
          .setQuestion(widget.category, widget.question.id, data,
              widget.totalQuestion, widget.newQuestion)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: widget.newQuestion! ? Text("NIEUW") : Text(widget.question.id!),
      content: Builder(builder: (context) {
        Size size = MediaQuery.of(context).size;
        return Container(
          width: kIsWeb ? size.width - 300 : size.width,
          height: size.height - 50,
          child: _isLoading
              ? CircularProgressIndicator()
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      showQuestion(context),
                      SizedBox(
                        height: 20,
                      ),
                      showOrder(context),
                      SizedBox(
                        height: 20,
                      ),
                      showUrl(context)
                      //         showCategories(context),
                    ],
                  ),
                ),
        );
      }),
      actions: <Widget>[
        TextButton(
              child: IntroGreyText(
                text: 'Cancel',
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
        SizedBox(
          width: 30,
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
            onPressed: () => saveQuestionChanges(context))
      ],
    );
  }
}
