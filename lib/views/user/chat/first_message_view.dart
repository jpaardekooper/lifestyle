import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/chat_controller.dart';
import 'package:lifestylescreening/models/admin_model.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/h3_green_blue_text.dart';
import 'package:lifestylescreening/widgets/text/h3_orange_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

import '../../../healthpoint_icons.dart';

class FirstMessageScreen extends StatefulWidget {
  FirstMessageScreen({this.model, this.email, this.hallo});

  final AdminModel? model;
  final String? email;
  final VoidCallback? hallo;

  @override
  _FirstMessageScreen createState() => _FirstMessageScreen();
}

class _FirstMessageScreen extends State<FirstMessageScreen> {
  ChatController _chatController = ChatController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H1Text(text: "Neem contact op"),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: widget.model!.medical!
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          onPressed: () =>
              {FocusScope.of(context).unfocus(), Navigator.of(context).pop()},
        ),
        bottom: PreferredSize(
            child: Container(
              color: widget.model!.medical!
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              height: 4.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.model!.medical!
                ? const Color(0xFFEFFAF6)
                : const Color(0xFFFFF4E6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.scale(
                      scale: 1.5,
                      child: CircleAvatar(
                        // backgroundImage: NetworkImage(widget.model.image),
                        child: Icon(Icons.person),
                        backgroundColor: widget.model!.medical!
                            ? const Color(0xFFA1CFBE)
                            : const Color(0xFFFFDFB9),
                      )),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      H2Text(text: widget.model!.name),
                      IntroGreyText(text: widget.model!.profession)
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              widget.model!.medical!
                  ? H3GreenBlueText(
                      text:
                          // ignore: lines_longer_than_80_chars
                          "Schrijf in het tekstvak hieronder uw vraag die u wilt stellen aan ${widget.model!.name}. Wij doen ons best om zo snel mogelijk te reageren!")
                  : H3OrangeText(
                      text:
                          // ignore: lines_longer_than_80_chars
                          "Schrijf in het tekstvak hieronder uw vraag die u wilt stellen aan ${widget.model!.name}. Wij doen ons best om zo snel mogelijk te reageren!"),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: widget.model!.medical!
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                      width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 22,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  controller: messageController,
                  cursorColor: widget.model!.medical!
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).accentColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Typ uw bericht...",
                    fillColor: Colors.grey[400],
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ConfirmOrangeButton(
                text: "Verstuur bericht",
                onTap: () => {
                  sendMessage(),
                },
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
        'description': messageController.text,
        'sender': true,
        'timestamp': DateTime.now(),
      };

      _chatController.sendMessageData(
          widget.email, chatMessage, widget.model!.expert_email, "");

      widget.hallo!();
      setState(() {
        messageController.clear();
      });
    }
  }
}
