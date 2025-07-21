import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/home/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _finishSplash = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        setState(() {
          _finishSplash = true;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _finishSplash ? StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if(snapshot.hasData) {
            return const ChatScreen();
          }

          return const SignInScreen();
        }
      ) : Center(
        child: Image.asset('assets/appicon.png',
          width: 200,
        ),
      ),
    );
  }
}