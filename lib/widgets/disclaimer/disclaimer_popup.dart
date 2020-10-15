import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/startup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerPopup extends StatelessWidget {
  const DisclaimerPopup({Key key}) : super(key: key);

  final keyIsFirstLoaded = 'is_first_loaded';

  @override
  Widget build(BuildContext context) {
    showDialogIfFirstLoaded(context);
    return StartUp();
  }

  showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null || isFirstLoaded != true) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            title: Text("Toestemmingsverklaring"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '''
Bedankt voor je aandacht voor dit onderzoek. 
Iedereen verdient een goede gezondheid. 
Dit is ons doel. Hiervoor is het ook belangrijk dat mensen goed voor zichzelf kunnen zorgen. 
  o	Hoe weet je of je goed voor jezelf zorgt? 
  o	Hoe meet je of je goed voor jezelf zorgt?
  o	Hoe verbeter je dit?
Dat zijn we aan het uitzoeken in dit onderzoek. 
Daarvoor willen we je vragen stellen.
Als je dit goedvindt.
Dit is geen test, er zijn geen goede of foute antwoorden. Al je antwoorden zijn waardevol.

We vragen niet om je naam en adres. Niemand weet dus welke antwoorden je geeft. Wel vragen we om andere informatie. Vragen stellen is de manier waarop we in dit onderzoek werken.
 
Door deze vragenlijst in te vullen geef je ons toestemming en laat je weten dat je: 
  o	voldoende informatie over het doel van dit onderzoek hebt
  o	voldoende informatie over de manier van werken van dit onderzoek hebt 
  o	weet dat je uit jezelf, vrijwillig meedoet 
  o	weet dat je altijd kunt stoppen:
    •	zonder dat je een reden op hoeft te geven
    •	en zonder dat dit gevolgen heeft 
  o	weet dat niemand weet welke antwoorden je geeft 
  o	antwoorden nog 10 jaar na afloop van dit onderzoek gebruikt kunnen worden voor het doel van dit onderzoek

Als je op volgende klikt, geef je toestemming hiervoor.
''',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text(
                  "Decline",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  prefs.setBool(keyIsFirstLoaded, false);
                },
              ),
              FlatButton(
                child: Text("volgende"),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  prefs.setBool(keyIsFirstLoaded, true);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
