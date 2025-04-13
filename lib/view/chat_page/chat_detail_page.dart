// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_application_1/constants/constants.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class ChatDetailScreen extends StatelessWidget {
//   final String chatId;
//
//   ChatDetailScreen({super.key, required this.chatId});
//
//   final currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   Widget build(BuildContext context) {
//     final messagesRef = FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           // Messages List
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: messagesRef.snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg['senderId'] == currentUserId;
//
//                     return Align(
//                       alignment:
//                           isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue[200] : Colors.grey[300],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(msg['message']),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//
//           // Message Input
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Consumer(
//                     builder: (_, WidgetRef ref, __) {
//                       final chatMessageController =
//                           ref.watch(chatProvider.chatMessageController);
//                       return TextField(
//                         controller: chatMessageController,
//                         decoration: const InputDecoration(
//                           hintText: 'Type your message...',
//                           border: OutlineInputBorder(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Consumer(
//                   builder: (_, WidgetRef ref, __) {
//                     final messageController =
//                         ref.read(chatProvider.chatMessageController);
//                     return IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: () {
//                         final text = messageController.text.trim();
//                         if (text.isNotEmpty) {
//                           chatService.sendMessage(
//                               message: text,
//                               chatId: chatId,
//                               currentUserId: currentUserId);
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailScreen extends StatelessWidget {
  final String chatId;
  ChatDetailScreen({super.key, required this.chatId});
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots(),
            builder: (context, chatSnapshot) {
              if (!chatSnapshot.hasData) return AppBar();

              final chatData = chatSnapshot.data!.data() as Map<String, dynamic>;
              final sellerId = chatData['sellerId'];
              final productId = chatData['productId'];

              return FutureBuilder<UserDetail>(
                future: authServices.getUserDetails(userId: sellerId),
                builder: (context, sellerSnapshot) {
                  return AppBar(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sellerSnapshot.data?.name ?? 'Loading...',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .doc(productId)
                              .snapshots(),
                          builder: (context, productSnapshot) {
                            return Text(
                              productSnapshot.data?['productName'] ?? 'Loading...',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(1),
                      child: Container(
                        color: AppColors.white.withOpacity(0.1),
                        height: 1,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == currentUserId;
                      final timestamp = msg['timestamp'] as Timestamp;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primary.withOpacity(0.9)
                                : AppColors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['message'],
                                style: TextStyle(
                                  color: isMe ? AppColors.white : AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(timestamp),
                                style: TextStyle(
                                  color: isMe
                                      ? AppColors.white.withOpacity(0.7)
                                      : AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final chatMessageController = ref.watch(chatProvider.chatMessageController);
                        return TextField(
                          controller: chatMessageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.6),
                            ),
                            filled: true,
                            fillColor: AppColors.primaryLight.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final messageController = ref.read(chatProvider.chatMessageController);
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: AppColors.white),
                          onPressed: () {
                            final text = messageController.text.trim();
                            if (text.isNotEmpty) {
                              chatService.sendMessage(
                                message: text,
                                chatId: chatId,
                                currentUserId: currentUserId,
                              );
                              messageController.clear();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day}/${date.month}';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}