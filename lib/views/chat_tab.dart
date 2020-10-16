import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/database.dart';

class ChatTab extends StatefulWidget {
  ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  TextEditingController messageController = TextEditingController();

  String userEmail = "";
  String description = "";

  Stream<QuerySnapshot> chats;

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
          MessageTile(message: ''' 
Welkom bij de chat van Lifestyle Monitor!

Hier kun u uw vragen stellen die u misschien kan hebben over deze applicatie.

Alles wat u hoeft te doen is een vraag typen en deze naar ons sturen, iemand van Lifestyle Monitor zal deze vraag zo snel mogelijk beantwoorden!
          ''', sendByMe: false),
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.red,
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Verstuur bericht",
                        fillColor: Colors.grey[400],
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[500], width: 2.0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(40)),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        'description': messageController.text ?? "",
        'open': true,
        'timestamp': DateTime.now(),
      };

      DatabaseService().sendMessageData(userEmail, chatMessage);

      setState(() {
        messageController.text = "";
      });
    }
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(userEmail)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          var message = snapshot.data;
          ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: message["description"],
                  sendByMe: userEmail == message.id,
                );
              });
        }
        return Container();
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  MessageTile({@required this.message, @required this.sendByMe});

  final String message;
  final bool sendByMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
