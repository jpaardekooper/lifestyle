import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello $name",
          style: TextStyle(
              fontSize: 24,
              color: Colors.red[400],
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Laten we samen werken aan ",
          style: TextStyle(fontSize: 19, color: Colors.grey[900]),
        ),
        Text(
          "een betere gezondheid!",
          style: TextStyle(fontSize: 19, color: Colors.grey[900]),
        ),
        SizedBox(
          height: 40,
        ),
        RichText(
          text: TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: 'Ranking '),
              TextSpan(
                text: 'Scores',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
