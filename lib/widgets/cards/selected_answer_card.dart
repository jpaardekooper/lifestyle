import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/widgets/forms/custom_answerfield.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/slider/slider.dart';

class SelectedAnswerCard extends StatefulWidget {
  SelectedAnswerCard(
      {Key key,
      @required this.answerList,
      @required this.controller,
      @required this.function})
      : super(key: key);
  final List<AnswerModel> answerList;
  final TextEditingController controller;
  final Function(AnswerModel) function;

  @override
  _SelectedAnswerCardState createState() => _SelectedAnswerCardState();
}

class _SelectedAnswerCardState extends State<SelectedAnswerCard> {
  bool isChecked = false;
  String selectedAnswer = "";

  Widget showClosedTile(AnswerModel answer, int index) {
    return Column(
      children: [
        index == 0
            ? CustomAnswerFormField(
                keyboardType: TextInputType.text,
                textcontroller: widget.controller,
                errorMessage: "Vergeten in te vullen",
                validator: 1, //checking if its a number
                answerModel: answer,
                function: widget.function,
              )
            : Container(),
        RadioListTile(
          //   dense: true,
          value: answer.option,
          groupValue: selectedAnswer,
          activeColor: Theme.of(context).accentColor,
          title: Text(answer.option),
          onChanged: (value) {
            setState(() {
              selectedAnswer = value;
              widget.controller.text = value;
            });
          },
          selected: selectedAnswer == answer.option,
        ),
      ],
    );
  }

  Widget showOpenTile(AnswerModel answer) {
    if (answer.option == "slider") {
      return Column(
        children: [
          CustomAnswerFormField(
            keyboardType: TextInputType.number,
            textcontroller: widget.controller,
            errorMessage: "Vergeten in te vullen",
            validator: 2, //checking if its a number
            answerModel: answer,
            function: widget.function,
          ),
          SliderWidget(
            controller: widget.controller,
          ),
        ],
      );
    } else {
      return CustomTextFormField(
        keyboardType: answer.optionTypeIsNumber
            ? TextInputType.number
            : TextInputType.text,
        textcontroller: widget.controller,
        errorMessage: "Geen geldig getal",
        validator: answer.optionTypeIsNumber ? 7 : 8, //checking if its a number
        secureText: false,
        hintText: "Antwoord in ${answer.option}",
        suffixText: answer.option,
        function: widget.function,
        answerModel: answer,
      );
    }
    // return Text("wow");
  }

  Widget showMultipleTile(AnswerModel answer) {
    return CheckboxListTile(
      value: isChecked,
      //   dense: true,
      //  value: widget.answerModel.option,
      //  groupValue: selectedAnswer,
      activeColor: Theme.of(context).accentColor,
      title: Text(answer.option),
      onChanged: (value) {
        setState(() {
          //   selectedAnswer = value;
          //        widget.textController.text = value;
        });
        //          widget.onTap(answered);
        //      widget.addAnswer(widget.i, answered);
      },
      selected: selectedAnswer == answer.option,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.answerList.length,
      itemBuilder: (context, index) {
        AnswerModel _answerModel = widget.answerList[index];

        switch (_answerModel.type) {
          case "AnswerType.closed":
            return showClosedTile(_answerModel, index);
            break;
          case "AnswerType.open":
            return showOpenTile(_answerModel);
            break;
          case "AnswerType.multipleChoice":
            return showMultipleTile(_answerModel);
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
