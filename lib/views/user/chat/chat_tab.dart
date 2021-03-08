import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/chat_controller.dart';
import 'package:lifestylescreening/models/admin_model.dart';
import 'package:lifestylescreening/models/user_message_model.dart';
import 'package:lifestylescreening/views/user/chat/chat_view.dart';
import 'package:lifestylescreening/views/user/chat/first_message_view.dart';

class ChatTab extends StatefulWidget {
  ChatTab({this.model, this.email});

  final AdminModel? model;
  final String? email;

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final ChatController _chatController = ChatController();

  List<UserMessageModel>? _userMessageModelList = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserMessageModel>>(
      future: _chatController.getUserChatRef(
          widget.email, widget.model!.expert_email),
      builder: (context, snapshot) {
        _userMessageModelList = snapshot.data;
        if (_userMessageModelList == null || _userMessageModelList!.isEmpty) {
          return FirstMessageScreen(
            model: widget.model,
            email: widget.email,
            hallo: hallo,
          );
        } else {
          UserMessageModel _userRef = _userMessageModelList![0];
          return ChatScreen(
            ref: _userRef,
            model: widget.model,
            email: widget.email,
          );
        }
      },
    );
  }

  void hallo() {
    setState(() {});
  }
}
