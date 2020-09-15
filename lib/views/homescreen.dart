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
            SizedBox(
              height: 16,
            ),
            Spacer(flex: 1),
            Material(
              color: Color.fromRGBO(72, 72, 72, 1),
              borderRadius: BorderRadius.circular(40),
              child: InkWell(
                borderRadius: BorderRadius.circular(40.0),
                child: blackButton(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Material(
              color: Color.fromRGBO(255, 129, 128, 1),
              borderRadius: BorderRadius.circular(40),
              child: InkWell(
                splashColor: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                child: whiteButton(context),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
              ),
            ),
            Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
