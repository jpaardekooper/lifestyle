import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class ResultsPage extends StatelessWidget {
  final String bmiResult;
  final String resultText;
  final String interpretation;

  const ResultsPage(
      {@required this.bmiResult,
      @required this.resultText,
      @required this.interpretation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Colors.white,
          onPressed: () =>
              {FocusScope.of(context).unfocus(), Navigator.of(context).pop()},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: H1Text(
                text: 'Uw resultaat',
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      resultText.toUpperCase(),
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bmiResult,
                    ),
                    Text(
                      interpretation,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ConfirmOrangeButton(
                text: 'Opnieuw berekenen',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
