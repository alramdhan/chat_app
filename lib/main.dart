import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/utilities/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeData = ThemeData.light(
    useMaterial3: true
  ).copyWith(
    colorScheme: AppColor.colorScheme,
    textTheme: GoogleFonts.robotoTextTheme(),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.colorScheme.primary,
    )
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const SignInScreen(),
    );
  }
}