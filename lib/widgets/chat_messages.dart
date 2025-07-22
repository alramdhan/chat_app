import 'package:chat_app/utilities/app_color.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
        .collection('chats')
        .orderBy(
          'createdAt',
          descending: true
        )
        .snapshots(),
      builder: (context, chatSnapshot) {
        if(chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.secondary),
          );
        }

        if(!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if(chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 12,
            right: 12
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            var chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
              ? loadedMessages[index + 1].data()
              : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId = nextChatMessage != null
              ? nextChatMessage['userId']
              : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if(nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                username: chatMessage['username'],
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }
          }
        );
      }
    );
    // return ListTile(
    //   leading: CircleAvatar(
    //     child: Text('Dika Al'.substring(0, 1),
    //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
    //         fontWeight: FontWeight.bold
    //       ),
    //     ),
    //   ),
    //   title: Text('Nama User',
    //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //       fontWeight: FontWeight.bold
    //     ),
    //   ),
    //   subtitle: Text('Pesan dan kesannya'),
    //   trailing: Text('time'),
    // );
  }
}