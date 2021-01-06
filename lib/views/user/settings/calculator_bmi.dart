import 'dart:math';

class CalculatorBMI {
  final int height;
  final int weight;
  double _bmi;

  CalculatorBMI({this.height, this.weight});

  String getBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi > 30)
      return 'Ernstig overgewicht';
    else if (_bmi > 25)
      return 'Overgewicht';
    else if (_bmi > 18.5)
      return 'Gezond gewicht';
    else
      return 'Ondergewicht';
  }

  String getInterpretation() {
    if (_bmi > 30)
      // ignore: lines_longer_than_80_chars
      return 'Je gewicht is veel te hoog. Het is beter voor je gezondheid om af te vallen. Maak een afspraak met je huisarts om je bloeddruk, cholesterol en bloedsuiker te laten meten.';
    else if (_bmi > 25)
      // ignore: lines_longer_than_80_chars
      return 'Je gewicht is te hoog. Het is beter voor je gezondheid om af te vallen. Maak een afspraak met je huisarts om je bloeddruk, cholesterol en bloedsuiker te controleren.';
    else if (_bmi > 18.5)
      // ignore: lines_longer_than_80_chars
      return 'Je gewicht is gezond. Mooi zo! Blijf gezond eten en voldoende bewegen om dat zo te houden.';
    else
      // ignore: lines_longer_than_80_chars
      return 'Je gewicht is veel te laag. Dit is niet goed voor je gezondheid. Neem contact op met je huisarts om de mogelijke oorzaak vast te stellen.';
  }
}
