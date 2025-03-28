import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';

class ChatService {
  Future<void> sendFirstMessage({
    required String message,
    required String sellerId,
    required String buyerId,
  }) async {
    try {
      String chatId = buyerId.hashCode <= sellerId.hashCode
          ? '${buyerId}_$sellerId'
          : '${sellerId}_$buyerId';

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      await chatRef.set({
        'buyerId': buyerId,
        'sellerId': sellerId,
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await chatRef.collection('messages').add({
        'message': message,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      globalFunctions.showToast(
          message:
              'Message Sended check tap on message icon on home page to see chats',
          toastType: ToastType.success);
    } catch (e) {
      globalFunctions.showLog(message: 'Error sending message: $e');
      globalFunctions.showToast(
          message: 'Error sending message: $e', toastType: ToastType.error);
    }
  }

  Future<void> sendMessage({
    required String message,
    required String chatId,
    required String currentUserId,
  }) async {
    try {
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      await chatRef.set({
        'lastMessage': message,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await chatRef.collection('messages').add({
        'message': message,
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      globalFunctions.showLog(message: 'Error sending message: $e');
    }
  }
}
