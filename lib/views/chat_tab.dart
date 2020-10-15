import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';

class ChatTab extends StatefulWidget {
  ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String userEmail = "";
  String description = "";

  getMyEmail() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        userEmail = value;
      });
    });
  }

  @override
  void initState() {
    getMyEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Tab"),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: "Message"),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => {
                      print("Hallo"),
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(40)),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage() {}
}
