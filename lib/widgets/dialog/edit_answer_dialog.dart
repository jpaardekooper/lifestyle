import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class Formule {
  const Formule(this.id, this.text);
  final int id;
  final String text;
}

class EditAnswerDialog extends StatefulWidget {
  const EditAnswerDialog({
    @required this.surveyId,
    @required this.question,
    @required this.answer,
    @required this.insertNewAnswer,
    @required this.totalQuestion,
  });
  final String surveyId;
  final QuestionModel question;
  final AnswerModel answer;
  final bool insertNewAnswer;
  final int totalQuestion;

  @override
  _EditAnswerDialogState createState() => _EditAnswerDialogState();
}

enum AnswerType { open, closed, multipleChoice }

class _EditAnswerDialogState extends State<EditAnswerDialog> {
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();
  TextEditingController nextController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  bool optionTypeIsNumber;
  TextEditingController pointsController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController lastAnswerCheckController = TextEditingController();

  AnswerType answerType;
  Formule selectedPointsCalculator;

  final List<Formule> formulas = <Formule>[
    const Formule(0, 'handmatig'),
    const Formule(1, 'Gegeven antwoord x 0.5'),
    const Formule(2, 'Gegeven antwoord x 1'),
    const Formule(3, 'Gegeven antwoord x 2'),
    const Formule(4, 'Gebaseerd op vorige antwoord'),
  ];

  //bool _isMultipleChoice;
  @override
  void initState() {
    super.initState();

    //  _isMultipleChoice = widget.answer.isMultipleChoice ?? true;
    orderController.text = (widget.answer.order ?? 0).toString();
    optionController.text = widget.answer.option ?? "";
    optionTypeIsNumber = widget.answer.optionTypeIsNumber ?? false;
    pointsController.text = (widget.answer.points ?? 0).toString();
    nextController.text =
        (widget.answer.next ?? widget.totalQuestion).toString();

    selectedPointsCalculator = formulas[widget.answer.pointsCalculator ?? 0];
    switch (widget.answer.type) {
      case "AnswerType.closed":
        answerType = AnswerType.closed;
        break;
      case "AnswerType.open":
        answerType = AnswerType.open;
        break;
      case "AnswerType.multipleChoice":
        answerType = AnswerType.multipleChoice;
        break;
      default:
        answerType = AnswerType.closed;
    }

    typeController.text = widget.answer.type ?? AnswerType.closed.toString();
    lastAnswerCheckController.text = widget.answer.lastAnswer ?? "none";

    _isLoading = false;
  }

  Widget showQuestion(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("vraag: ${widget.question.order}"),
        SizedBox(
          height: 10,
        ),
        H2Text(text: widget.question.question),
      ],
    );
  }

  Widget showAnswer(BuildContext context) {
    switch (answerType) {
      case AnswerType.multipleChoice:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.article),
                SizedBox(
                  width: 10,
                ),
                Text("Gebruiker selecteerd antwoord"),
              ],
            ),
            CustomTextFormField(
              keyboardType: TextInputType.text,
              textcontroller: optionController,
              errorMessage: "Geen geldige optie",
              validator: 1,
              secureText: false,
            ),
          ],
        );
        break;
      case AnswerType.closed:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.radio_button_checked),
                SizedBox(
                  width: 10,
                ),
                Text("Gesloten antwoord:")
              ],
            ),
            CustomTextFormField(
              keyboardType: TextInputType.text,
              textcontroller: optionController,
              errorMessage: "Geen geldige optie",
              validator: 1,
              secureText: false,
            ),
          ],
        );
        break;
      case AnswerType.open:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.check_box),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child:
                              H2Text(text: "Gebruiker geeft antwoord in...")),
                    ],
                  ),
                ),
                Flexible(
                  child: H2Text(text: "Is het antwoord in cijfers? ja/nee"),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    textcontroller: optionController,
                    errorMessage: "Geen geldige optie",
                    validator: 1,
                    secureText: false,
                  ),
                ),
                Flexible(
                  child: Switch(
                    value: optionTypeIsNumber,
                    onChanged: (value) {
                      setState(() {
                        optionTypeIsNumber = value;
                      });
                    },
                    activeTrackColor: ColorTheme.orange,
                    activeColor: ColorTheme.accentOrange,
                  ),
                ),
              ],
            ),
          ],
        );
        break;
    }
  }

  Widget showAnswerType(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        H2Text(text: "Wat voor soort vraag is het?"),
        RadioListTile<AnswerType>(
          title: Text("gesloten"),
          value: AnswerType.closed,
          groupValue: answerType,
          onChanged: (AnswerType value) {
            setState(() {
              answerType = value;
              typeController.text = value.toString();
            });
          },
        ),
        RadioListTile<AnswerType>(
          title: Text("open"),
          value: AnswerType.open,
          groupValue: answerType,
          onChanged: (AnswerType value) {
            setState(() {
              answerType = value;
              typeController.text = value.toString();
            });
          },
        ),
        RadioListTile<AnswerType>(
          title: Text("meerkeuze"),
          value: AnswerType.multipleChoice,
          groupValue: answerType,
          onChanged: (AnswerType value) {
            setState(() {
              answerType = value;
              typeController.text = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget showOrder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: H2Text(text: "Volgorde van het antwoord"),
        ),
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: orderController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showPoints(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child:
              H2Text(text: "Aantal punten als er gekozen is voor dit antwoord"),
        ),
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: pointsController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showPointsforLastQuestion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 3,
            child: H2Text(
                text: "Indien er bij het vorige antwoord ... is ingevuld")),
        Flexible(
          flex: 2,
          child: CustomTextFormField(
            keyboardType: TextInputType.text,
            textcontroller: lastAnswerCheckController,
            errorMessage: "Graag iets invullen",
            hintText: 'ja / nee',
            validator: 1,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showPointsFormula(BuildContext context) {
    return DropdownButton<Formule>(
      value: selectedPointsCalculator,
      hint: Text("selecteer een formule"),
      onChanged: (Formule newValue) {
        setState(() {
          selectedPointsCalculator = newValue;
          pointsController.text = 0.toString();
        });
      },
      items: formulas.map((Formule formule) {
        return DropdownMenuItem<Formule>(
          value: formule,
          child: Text(
            formule.text,
          ),
        );
      }).toList(),
    );
  }

  Widget showGoToNextQuestion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 3,
            child: H2Text(
                text:
                    "Indien de gebruiker heeft geantwoord ga door naar vraag...")),
        Flexible(
          child: CustomTextFormField(
            keyboardType: TextInputType.number,
            textcontroller: nextController,
            errorMessage: "Geen geldige getal",
            validator: 6,
            secureText: false,
          ),
        ),
      ],
    );
  }

  Widget showEditWidgets(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(
          height: 20,
        ),
        showAnswerType(context),
        Divider(),
        SizedBox(
          height: 20,
        ),
        showAnswer(context),
        Divider(),
        SizedBox(
          height: 20,
        ),
        showGoToNextQuestion(context),
        Divider(),
        SizedBox(
          height: 20,
        ),
        showOrder(context),
        Divider(),
        SizedBox(
          height: 20,
        ),
        showPointsFormula(context),
        SizedBox(
          height: 20,
        ),
        selectedPointsCalculator == formulas[4]
            ? showPointsforLastQuestion(context)
            : Container(),
        Divider(),
        SizedBox(
          height: 20,
        ),
        selectedPointsCalculator == formulas[0] ||
                selectedPointsCalculator == formulas[4]
            ? showPoints(context)
            : Container(),
      ],
    );
  }

  void saveAnswerChanges(BuildContext context) {
    if (_formKey.currentState.validate()) {
      // category,example,has_followup,next,order,question,

      Map<String, dynamic> data = {
        "next": int.parse(nextController.text),
        "option": optionController.text,
        "option_type_is_number": optionTypeIsNumber,
        "order": int.parse(orderController.text),
        "points": int.parse(pointsController.text),
        "pointsCalculator": selectedPointsCalculator.id,
        "type": typeController.text,
        "lastAnswer": lastAnswerCheckController.text,
      };
      _questionnaireController
          .setAnswer(widget.surveyId, widget.question.id, widget.answer.id,
              data, widget.insertNewAnswer)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      // title: widget.answer. ? Text("NIEUW") : Text(widget.question.id),
      content: Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return Container(
            width: kIsWeb ? size.width - 300 : size.width,
            child: SingleChildScrollView(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          showQuestion(context),
                          showEditWidgets(context),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),

      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(
          width: 30,
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => saveAnswerChanges(context),
        )
      ],
    );
  }
}
