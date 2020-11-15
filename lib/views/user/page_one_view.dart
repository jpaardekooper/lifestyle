import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/views/startup.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("name: ${_userData.data.userName}"),
          IconButton(
            onPressed: () async {
              //  await auth.signOut();
              await HelperFunctions.saveUserLoggedInSharedPreference(false);
              await HelperFunctions.removeUserNameSharedPreference();
              await HelperFunctions.removeUserEmailSharedPreference();
              await HelperFunctions.removeUserPasswordSharedPreference();

              await Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => StartUp()));
            },
            icon: Icon(
              Icons.exit_to_app,
              size: 26.0,
            ),
          )
        ],
      ),
    );
  }
}
