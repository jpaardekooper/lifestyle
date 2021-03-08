import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({
    Key? key,
    required this.controller,
    //@required this.function,
  }) : super(key: key);

  final TextEditingController? controller;
  // final Function(AnswerModel, String) function;

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double value = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            H2Text(
              text: '${value.round()}',
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
              activeTrackColor: ColorTheme.lightOrange,
              inactiveTrackColor: Color(0xff8d8e98),
              thumbColor: Theme.of(context).accentColor,
              overlayColor: Color(0x29eb1555)),
          child: Slider(
            value: value.toDouble(),
            min: 1.0,
            max: 10.0,
            onChangeEnd: (val) {
              widget.controller!.text = val.round().toString();
            },
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
          ),
        ),
      ],
    );
  }
}
