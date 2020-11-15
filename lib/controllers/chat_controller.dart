import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/repositories/chat_repository.dart';
import 'package:lifestylescreening/repositories/chat_repository_interface.dart';

class ChatController {
  final IChatRepository _chatController = ChatRepository();

  //stream chat for user client
  Stream<QuerySnapshot> streamUserChat(String email, String category) {
    return _chatController.streamUserChat(email, category);
  }

  //stream chat for admin client
  Stream<QuerySnapshot> streamAdminChat(String userId) {
    return _chatController.streamAdminChat(userId);
  }

  Future<void> sendMessageData(String email, Map chatMessage, String category) {
    return _chatController.sendMessageData(email, chatMessage, category);
  }

  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage) {
    return _chatController.sendMessageDataAsAdmin(id, chatMessage);
  }
}
