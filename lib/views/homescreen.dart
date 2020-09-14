import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/signin.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 24),
        color: Color.fromRGBO(255, 129, 128, 1),
        child: Column(
          children: [
            Spacer(flex: 2),
            appName(context),
            Spacer(flex: 2),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              child: blackButton(context),
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
              child: whiteButton(context),
            ),
            Spacer(flex: 5),
          ],
        ),
      ),
    );
  }
}
