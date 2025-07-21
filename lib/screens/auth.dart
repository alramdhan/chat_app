import 'package:chat_app/utilities/app_color.dart';
import 'package:chat_app/widgets/flutter_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firebase = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredFName = '';
  String _enteredLName = '';
  String _enteredEmail = '';
  String _enteredPwd = '';
  bool _isLogin = true;
  bool _isSignInPressed = false;

  void _submit() async {
    setState(() {
      _isSignInPressed = true;
    });
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if(_isLogin) {
          // log in user
          final userCredentials = await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPwd);

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign In Successfully. Welcome back ${userCredentials.user?.displayName ?? userCredentials.user?.uid}'))
          );
          // Navigator.pushReplacement(context,
          //   MaterialPageRoute(builder: (_) => const ChatScreen())
          // );
        } else {
          final userCredentials = await _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPwd);
          await userCredentials.user?.updateDisplayName('$_enteredFName $_enteredLName');
          // ScaffoldMessenger.of(context).clearSnackBars();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Register account successfully.'))
          // );
        }
      } on FirebaseAuthException catch(e) {
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
      FlutterAppTextField(
        validator: (value) {
          if(value == null || value.trim().isEmpty) {
            return 'Please input a valid First Name.';
          }

          return null;
        },
        onSaved: (value) {
          _enteredFName = value!;
        },
        label: const Text('First Name'),
      ),
      FlutterAppTextField(
        validator: (value) {
          if(value == null || value.trim().isEmpty) {
            return 'Please input a valid Last Name.';
          }

          return null;
        },
        onSaved: (value) {
          _enteredLName = value!;
        },
        label: const Text('Last Name'),
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
                            width: 45,
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