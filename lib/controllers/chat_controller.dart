import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/admin_model.dart';
import 'package:lifestylescreening/models/message_model.dart';
import 'package:lifestylescreening/models/user_message_model.dart';
import 'package:lifestylescreening/repositories/chat_repository.dart';
import 'package:lifestylescreening/repositories/chat_repository_interface.dart';

class ChatController {
  final IChatRepository _chatController = ChatRepository();

  //stream chat for user client
  Future<List<UserMessageModel>> getUserChatRef(
      String? email, String? expert_email) {
    return _chatController.getUserChatRef(email, expert_email);
  }

  //stream chat for user client
  Stream<QuerySnapshot> streamUserChat(String? ref) {
    return _chatController.streamUserChat(ref);
  }

  //stream chat for admin client
  Stream<QuerySnapshot> streamAdminChat(String? userId) {
    return _chatController.streamAdminChat(userId);
  }

  Stream<QuerySnapshot> streamUserMessage(String? email) {
    return _chatController.streamUserMessage(email);
  }

  List<UserMessageModel> getUserMessageList(QuerySnapshot snapshot) {
    return _chatController.getUserMessageList(snapshot);
  }

  List<MessageModel> getMessageList(QuerySnapshot snapshot) {
    return _chatController.getMessageList(snapshot);
  }

  Future<List<AdminModel>> getExperts() {
    return _chatController.getExperts();
  }

  Future<void> sendMessageData(
      String? email, Map chatMessage, String? expert_email, String? ref) {
    return _chatController.sendMessageData(
        email, chatMessage, expert_email, ref);
  }

  Future<void> sendMessageDataAsAdmin(String? id, Map chatMessage) {
    return _chatController.sendMessageDataAsAdmin(id, chatMessage);
  }

  Future<void> closeChat(String id) {
    return _chatController.closeChat(id);
  }
}
