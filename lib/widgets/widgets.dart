import 'package:flutter/material.dart';

// Widget appName(BuildContext context) {
//   return Text(
//     'MHealth',
//     style: TextStyle(
//         fontWeight: FontWeight.w500, color: Colors.white, fontSize: 50),
//   );
// }

//big
// Widget blackButton(BuildContext context) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 18),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(40),
//     ),
//     alignment: Alignment.center,
//     //depending on margin at line number 27 times 2
//     width: MediaQuery.of(context).size.width / 2,
//     child: Text(
//       "Inloggen",
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 30,
//       ),
//     ),
//   );
// }

//big
// Widget whiteButton(BuildContext context) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 18),
//     decoration: BoxDecoration(
//       //    color: Color.fromRGBO(255, 129, 128, 1),
//       borderRadius: BorderRadius.circular(40),
//       border: Border.all(color: Colors.white, width: 4),
//     ),
//     alignment: Alignment.center,
//     width: MediaQuery.of(context).size.width / 2,
//     child: Text(
//       "Aanmelden",
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 30,
//       ),
//     ),
//   );
// }

//small
Widget smallblackButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      //     color: Color.fromRGBO(72, 72, 72, 1),
      borderRadius: BorderRadius.circular(40),
      //  border: Border.all(color: Color.fromRGBO(72, 72, 72, 1), width: 4),
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
          text: 'Lifestyles',
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
    isDense: true,
    contentPadding: EdgeInsets.all(11),
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
  );
}

InputDecoration themedecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.black54,
      fontFamily: 'OverpassRegular',
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
    ),
  );
}

Widget blueButton({BuildContext context, String label, buttonWidth}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4), color: Colors.black),
    alignment: Alignment.center,
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

class NoOfQuestionTile extends StatefulWidget {
  NoOfQuestionTile({this.text, this.number});
  final String text;
  final int number;

  @override
  _NoOfQuestionTileState createState() => _NoOfQuestionTileState();
}

class _NoOfQuestionTileState extends State<NoOfQuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
                color: Colors.blue),
            child: Text(
              "${widget.number}",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                color: Colors.black54),
            child: Text(
              widget.text,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
