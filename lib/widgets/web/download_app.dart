import 'package:flutter/material.dart';

class DownloadApp extends StatelessWidget {
  const DownloadApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ervaar het gemak",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              "Van de Lifestyle Screening app",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 30,
            ),
            Image(
              width: 200,
              image: AssetImage('playstore.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("4.7"),
                Icon(Icons.star, color: Colors.orange[400]),
                Icon(Icons.star, color: Colors.orange[400]),
                Icon(Icons.star, color: Colors.orange[400]),
                Icon(Icons.star, color: Colors.orange[400]),
                Icon(Icons.star_half, color: Colors.orange[400]),
              ],
            )
          ],
        ),
        SizedBox(
          width: 50,
        ),
        Image(
          width: 350,
          image: AssetImage('health.png'),
        ),
      ],
    );
  }
}
