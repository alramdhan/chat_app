import 'package:flutter/material.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('Dika Al'.substring(0, 1),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              title: Text('Nama User',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
              subtitle: Text('Pesan dan kesannya'),
              trailing: Text('time'),
            );
          }
        ),
      ),
    );
  }
}