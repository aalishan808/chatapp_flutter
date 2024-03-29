import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(FlashChat());
}
class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
    MaterialApp(
   theme: ThemeData(textTheme: TextTheme(
  bodyText1: TextStyle(color: Colors.black54),
  )
  ),
    initialRoute: WelcomeScreen.id,
  routes: {
  ChatScreen.id:(context)=>ChatScreen(),
  LoginScreen.id:(context)=> LoginScreen(),
  RegistrationScreen.id:(context)=>RegistrationScreen(),
  WelcomeScreen.id:(context)=>WelcomeScreen()
  },
  );
  }
}