import 'package:chat_app/screens/home/list_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPwd = '';
  bool _isLogin = true;

  void _submit() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if(_isLogin) {
        // log in user
        print(_enteredEmail);
        print(_enteredPwd);
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const ListChatScreen())
        );
      } else {
        try {
          final userCredential = await _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPwd);
          
          print("user cr $userCredential");
          setState(() {
            _isLogin = !_isLogin;
          });
          
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register account successfully.'))
          );
        } on FirebaseAuthException catch(e) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Authentication Failed.'))
          );
          throw('Error: ${e.message}');
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: Image.asset('assets/appicon.png'),
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
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          autocorrect: false,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty || !value.contains('@')) {
                              return 'Please input a valid Email address.';
                            }
                  
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          decoration: const InputDecoration(
                            label: Text('Email')
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
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
                          decoration: const InputDecoration(
                            label: Text('Password')
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(
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