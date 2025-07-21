import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chat_app/widgets/list_chat.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _onLogout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat App',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onLogout,
            icon: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: Colors.white,
            )
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (ctx, index) {
            return const ListChat();
          }
        ),
      ),
    );
  }
}