import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class DownloadApp extends StatelessWidget {
  const DownloadApp({Key? key, required this.number}) : super(key: key);
  final int? number;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          number == 8
              ? Center(
                  child: H1Text(
                    text:
                        "Overleg met uw huisarts alvorens de app te downloaden",
                  ),
                )
              : Container(),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                  size.width < 900
                      ? Image(
                          height: 350,
                          image: AssetImage('health.png'),
                        )
                      : Container()
                ],
              ),
              SizedBox(
                width: 50,
              ),
              size.width > 900
                  ? Image(
                      //         width: 350,
                      height: 350,
                      image: AssetImage('health.png'),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
