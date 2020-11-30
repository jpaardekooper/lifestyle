import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/admin_model.dart';
import 'package:lifestylescreening/models/message_model.dart';
import 'package:lifestylescreening/models/user_message_model.dart';

abstract class IChatRepository {
  Future<List<UserMessageModel>> getUserChatRef(
      String email, String expert_email);

  Stream<QuerySnapshot> streamUserChat(String ref);

  Stream<QuerySnapshot> streamAdminChat(String userId);

  Stream<QuerySnapshot> streamUserMessage(String email);

  List<UserMessageModel> getUserMessageList(QuerySnapshot snapshot);

  List<MessageModel> getMessageList(QuerySnapshot snapshot);

  Future<List<AdminModel>> getExperts();

  Future<void> sendMessageData(
      String email, Map chatMessage, String expert_email, String id);

  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage);

  Future<void> closeChat(String id);
}
