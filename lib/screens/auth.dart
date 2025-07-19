import 'package:chat_app/utilities/app_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  right: 20,
                  bottom: 20,
                  left: 20
                ),
                width: 200,
                child: Image.asset('assets/appicon.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        !_isLogin ? Container(
                          child: Text('Image'),
                        ) : const SizedBox(),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,

                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary
                          ),
                          child: Text(_isLogin ? 'Sign In' : 'Sign Up')
                        ),
                        const SizedBox(height: 16),
                        const Text('Or'),
                        const SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: _isLogin ? 'Doesn\'t have an account? ' : 'I already have an Account. ',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            children: [
                              TextSpan(
                                text: _isLogin ? 'Sign Up Here' : 'Sign In',
                                style: const TextStyle(color: AppColor.primary),
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
        )
      ),
    );
  }
}