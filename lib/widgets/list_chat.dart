import 'package:flutter/material.dart';

class ListChat extends StatelessWidget {
  const ListChat({super.key});

  @override
  Widget build(BuildContext context) {
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
}