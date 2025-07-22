import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
    this.isFirstInSequence = true
  });

  const MessageBubble.next({
    super.key,
    this.userImage,
    this.username,
    required this.message,
    required this.isMe,
    this.isFirstInSequence = false
  });

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.
  final String? userImage;

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String? username;
  final String message;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        if(userImage != null)
          Positioned(
            top: 15,
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage!),
              backgroundColor: theme.colorScheme.primary.withAlpha(100),
              radius: 24,
            ),
          ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if(isFirstInSequence) const SizedBox(height: 18),
                  if(username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                      ),
                    ),

                  // The "Speech" box surrounding the messages
                  Container(
                    decoration: BoxDecoration(
                      color: isMe ? Colors.grey.shade300 : theme.colorScheme.secondary.withAlpha(200),
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                        topRight: isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                          ? Colors.black87
                          : theme.colorScheme.onSecondary
                      ),
                      softWrap: true,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}