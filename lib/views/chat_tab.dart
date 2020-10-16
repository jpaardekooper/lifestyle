import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

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

  @override
  void initState() {
    getMyEmail();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  getMyEmail() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        userEmail = value;
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Chat Tab"),
        backgroundColor: Colors.red,
      ),
      body: userEmail != ""
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(userEmail)
                  .collection("user_message")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("Type uw vraag");
                return FadeInTransition(
                  child: ListView(
                    children: getMessageData(snapshot),
                  ),
                );
              })
          : welcomeChatMessage(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
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

  welcomeChatMessage() {
    return MessageTile(
      message: '''
Welkom bij de chat van Lifestyle Monitor!
Hier kun u uw vragen stellen die u misschien kan hebben over deze applicatie.
Alles wat u hoeft te doen is een vraag typen en deze naar ons sturen, iemand van Lifestyle Monitor zal deze vraag zo snel mogelijk beantwoorden!
          ''',
      sendByMe: false,
      dateTime: "",
    );
  }

  getMessageData(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map((doc) => MessageTile(
              message: doc["description"],
              // sendByMe: userEmail == doc.id,
              sendByMe: doc["open"],
              dateTime: doc["timestamp"].toDate().toIso8601String(),
            ))
        .toList();
  }
}

class MessageTile extends StatefulWidget {
  MessageTile({@required this.message, @required this.sendByMe, this.dateTime});

  final String message;
  final String dateTime;
  final bool sendByMe;

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.sendByMe
            //true
            ? Container(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  widget.dateTime,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ))
            //false
            : Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  widget.dateTime,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
        Container(
          margin: widget.sendByMe
              //true
              ? EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 3.5,
                  right: 8,
                  top: 8,
                  bottom: 8)
              //false
              : EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                  right: MediaQuery.of(context).size.width / 3.5),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            color: widget.sendByMe
                //true
                ? Color(0xff007EF4)
                //false
                : Colors.red,
          ),
          child: Text(widget.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
        ),
      ],
    );
  }
}
