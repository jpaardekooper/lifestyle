import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/repositories/chat_repository_interface.dart';

class ChatRepository extends IChatRepository {
  @override
  Stream<QuerySnapshot> streamUserChat(String email, String category) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(email + "_" + category)
        .collection("user_message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot> streamAdminChat(String userId) {
    return FirebaseFirestore.instance
        .collection("messages")
        .doc(userId)
        .collection("user_message")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  @override
  Future<void> sendMessageData(
      String email, Map chatMessage, String category) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(email + "_" + category)
        .collection("user_message")
        .doc()
        .set(chatMessage)
        .catchError((e) {
      //    print(e);
    });

    await FirebaseFirestore.instance
        .collection("messages")
        .doc(email + "_" + category)
        .set({
      'open': true,
      'category': category,
    }).catchError((e) {});
  }

  @override
  Future<void> sendMessageDataAsAdmin(String id, Map chatMessage) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(id)
        .collection("user_message")
        .doc()
        .set(chatMessage)
        .catchError((e) {
      //    print(e);
    });
  }
}
