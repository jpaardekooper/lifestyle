import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * 0.05,
        ),
        Hero(
            tag: 'intro-text',
            child: Wrap(
              children: [
                H1Text(text: 'HealthPoint'),
                H1Text(text: 'Toestemmingsverklaring'),
              ],
            )),
        SizedBox(
          height: 15,
        ),
        Text(
          '''
Bedankt voor je aandacht voor dit onderzoek. 
Iedereen verdient een goede gezondheid. 
Dit is ons doel. Hiervoor is het ook belangrijk dat mensen goed voor zichzelf kunnen zorgen. 
  o	Hoe weet je of je goed voor jezelf zorgt? 
  o	Hoe meet je of je goed voor jezelf zorgt?
  o	Hoe verbeter je dit?

Dat zijn we aan het uitzoeken in dit onderzoek. 
Daarvoor willen we je vragen stellen. Als je dit goedvindt.
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
          style: TextStyle(fontSize: size.height * 0.025),
        ),
      ],
    );
  }
}
