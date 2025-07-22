import 'dart:io';

import 'package:chat_app/utilities/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/widgets/flutter_text_field.dart';
import 'package:chat_app/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String _enteredUName = '';
  String _enteredFName = '';
  String _enteredEmail = '';
  String _enteredPwd = '';
  bool _isLogin = true;
  bool _isSignInPressed = false;

  void _submit() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isSignInPressed = true;
        });

        if(_isLogin) {
          // log in user
          final userCredentials = await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPwd);

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign In Successfully. Welcome back ${userCredentials.user?.displayName ?? userCredentials.user?.uid}'))
          );
        } else {
          if(_selectedImage == null) return;

          final userCredentials = await _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPwd);
          await userCredentials.user?.updateDisplayName(_enteredFName);

          // final storageRef = FirebaseStorage.instance.ref();
          // await storageRef.child('user_images')
          //   .child('${userCredentials.user?.uid}.jpg')
          //   .putFile(_selectedImage!);
          // final imageURL = await storageRef.getDownloadURL();
          // print("imageURL $imageURL");

          await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user?.uid)
            .set({
              "user_name": _enteredUName,
              "full_name": _enteredFName,
              "email": _enteredEmail,
              "image_url": 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png', // imageURL from firebase storage
            });

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account register successfully.'))
          );
        }
      } on FirebaseAuthException catch(e) {
        setState(() {
          _isSignInPressed = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication Failed.'))
        );
        print('Error: ${e.message}');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final formNameRegister = <Widget>[
      UserImagePicker(
        onPickImage: (pickedImage) {
          _selectedImage = pickedImage;
        },
      ),
      FlutterAppTextField(
        enableSuggestions: false,
        validator: (value) {
          if(value == null || value.trim().isEmpty || value.trim().length < 4) {
            return 'Please enter at least 4 characters.';
          }

          return null;
        },
        onSaved: (value) {
          _enteredUName = value!;
        },
        label: const Text('User Name'),
      ),
      FlutterAppTextField(
        validator: (value) {
          if(value == null || value.trim().isEmpty) {
            return 'Please enter a valid Full Name.';
          }

          return null;
        },
        onSaved: (value) {
          _enteredFName = value!;
        },
        label: const Text('Full Name'),
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: Image.asset(
                  'assets/appicon.png',
                  fit: BoxFit.cover,
                ),
              ),
              Card(
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  bottom: 20,
                  right: 20
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ...!_isLogin ? formNameRegister : [const SizedBox()],
                        FlutterAppTextField(
                          keyboardType: TextInputType.emailAddress,
                          autoCorrect: false,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty || !value.contains('@')) {
                              return 'Please input a valid Email address.';
                            }
                  
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          label: const Text('Email')
                        ),
                        FlutterAppTextField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty || value.trim().length < 6) {
                              return 'Please input a valid Password.';
                            }
                  
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPwd = value!;
                          },
                          label: const Text('Password')
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isSignInPressed ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: _isSignInPressed ? const SizedBox(
                            width: 38,
                            child: CircularProgressIndicator(
                              color: AppColor.secondary,
                            ),
                          ) : Text(
                            _isLogin ? 'Sign In' : 'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface
                            )
                          )
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface
                            ),
                            text: _isLogin ? 'Doesn\'t have an account? ' : 'I already have an account. ',
                            children: [
                              TextSpan(
                                text: _isLogin ? 'Sign Up Here' : 'Sign In',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                }
                              )
                            ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}