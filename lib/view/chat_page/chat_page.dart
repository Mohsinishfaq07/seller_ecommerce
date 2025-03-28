import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/view/chat_page/chat_detail_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Chats',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('buyerId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, buyerSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where('sellerId', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, sellerSnapshot) {
              if (buyerSnapshot.connectionState == ConnectionState.waiting ||
                  sellerSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Combine both buyer and seller chats
              final allDocs = [
                ...buyerSnapshot.data!.docs,
                ...sellerSnapshot.data!.docs
              ];

              if (allDocs.isEmpty) {
                return const Center(child: Text('No chats found.'));
              }

              return ListView.builder(
                itemCount: allDocs.length,
                itemBuilder: (context, index) {
                  final chat = allDocs[index];
                  final lastMessage = chat['lastMessage'] ?? '';
                  final buyerId = chat['buyerId'];
                  final sellerId = chat['sellerId'];
                  final chatId = chat.id;

                  final otherUserId =
                      currentUserId == buyerId ? sellerId : buyerId;

                  return FutureBuilder<UserDetail>(
                    future: authServices.getUserDetails(userId: otherUserId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const ListTile(title: Text('Loading...'));
                      }

                      final userDetail = snapshot.data!;
                      return ListTile(
                        title: Text('Name: ${userDetail.name}'),
                        subtitle: Text('Last Message: $lastMessage'),
                        onTap: () {
                          globalFunctions.nextScreen(
                            context,
                            ChatDetailScreen(chatId: chatId),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
