import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/widgets/transitions/fade_transition.dart';

class ChatTab extends StatefulWidget {
  ChatTab({@required this.email, @required this.category, this.sender});

  final String email;
  final String category;
  final bool sender;

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  TextEditingController messageController = TextEditingController();

  // String userEmail = "";
  String description = "";

  Stream<QuerySnapshot> chats;

  @override
  void initState() {
    //   getMyEmail();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  // getMyEmail() async {
  //   await HelperFunctions.getUserEmailSharedPreference().then((value) {
  //     setState(() {
  //       userEmail = value;
  //     });
  //   });
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(widget.email + "_" + widget.category)
                  .collection("user_message")
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  return welcomeChatMessage();
                }
                if (snapshot.data.docs.isEmpty) {
                  return welcomeChatMessage();
                }
                return ListView.builder(
                  reverse: false,
                  padding: EdgeInsets.all(20),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FadeInTransition(
                      child: MessageTile(
                        message:
                            snapshot.data.docs[index].data()["description"],
                        sendByMe: snapshot.data.docs[index].data()["sender"],
                        dateTime: snapshot.data.docs[index]
                            .data()["timestamp"]
                            .toDate()
                            .toString(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: Colors.red,
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Verstuur bericht",
                        fillColor: Colors.grey[400],
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[500], width: 1.0),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        contentPadding: EdgeInsets.only(left: 32, right: 32)),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              GestureDetector(
                onTap: () async {
                  await sendMessage();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessage = {
        'description': messageController.text ?? "",
        'sender': true,
        'timestamp': DateTime.now(),
      };

      DatabaseService()
          .sendMessageData(widget.email, chatMessage, widget.category);

      setState(() {
        messageController.clear();
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

  // getMessageData(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return snapshot.data.docs
  //       .map((doc) => MessageTile(
  //           message: doc["description"],
  //           // sendByMe:,
  //           sendByMe: widget.email == doc.id,
  //           dateTime: doc["timestamp"].toDate().toString()))
  //       .toList();
  // }
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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.sendByMe
                //true
                ? Color(0xff007EF4)
                //false
                : Colors.red,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(widget.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
        ),
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
      ],
    );
  }
}
