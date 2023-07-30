import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatapp/components/rounded_button.dart';
class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation animation;
  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,

    );
 //   animation= CurvedAnimation(parent: animationController, curve: Curves.easeIn);
   animation = ColorTween(begin: Colors.blue,end: Colors.white).animate(animationController);
    animationController.forward();

    // animation.addStatusListener((status) {
    //  if(status == AnimationStatus.completed){
    //    animationController.reverse(from:1.0);
    //  }
    //  else if(status == AnimationStatus.dismissed){
    //    animationController.forward();
    //  }
    // });
    animationController.addListener(() {
      setState(() {

      });
      print(animation.value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(

                    child: Image.asset('images/logo.png'),
                    height: 60,

                  ),

                ),

                TypewriterAnimatedTextKit(
                  text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900
                  )
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
           RoundedButton(title: "Register",
               colour: Colors.blueAccent,
               onPressed: (){
             Navigator.pushNamed(context,RegistrationScreen.id);
           })
          ],
        ),
      ),
    );
  }
}
