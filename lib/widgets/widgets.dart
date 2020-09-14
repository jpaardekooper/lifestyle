import 'package:flutter/material.dart';

Widget appName(BuildContext context) {
  return Text(
    'MHealth',
    style: TextStyle(
        fontWeight: FontWeight.w500, color: Colors.white, fontSize: 50),
  );
}

//big
Widget blackButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Color.fromRGBO(72, 72, 72, 1),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Color.fromRGBO(72, 72, 72, 1), width: 4),
    ),
    alignment: Alignment.center,
    //depending on margin at line number 27 times 2
    width: MediaQuery.of(context).size.width / 2,
    child: Text(
      "Inloggen",
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
  );
}

//big
Widget whiteButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 129, 128, 1),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Colors.white, width: 4),
    ),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width / 2,
    child: Text(
      "Aanmelden",
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
  );
}

//small
Widget smallblackButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Color.fromRGBO(72, 72, 72, 1),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Color.fromRGBO(72, 72, 72, 1), width: 4),
    ),
    alignment: Alignment.center,
    //depending on margin at line number 27 times 2
    width: MediaQuery.of(context).size.width / 3,
    child: Text(
      "Inloggen",
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),
    ),
  );
}

//small
Widget smallwhiteButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 129, 128, 1),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Colors.white, width: 2),
    ),
    alignment: Alignment.center,
    //depending on margin at line number 27 times 2
    width: MediaQuery.of(context).size.width / 3,
    child: Text(
      "Terug",
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),
    ),
  );
}

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
          text: 'Lifestyle',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        TextSpan(
          text: ' Screening',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
        ),
      ],
    ),
  );
}

inputDecoration(BuildContext context) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
  );
}
