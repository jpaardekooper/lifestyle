import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IChatRepository {
  Stream<QuerySnapshot> streamUserChat(String email, String category);

  Stream<QuerySnapshot> streamAdminChat(String userId);

  Future<void> sendMessageData(String email, Map chatMessage, String category);

  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage);
}
