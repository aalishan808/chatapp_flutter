import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:chatapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;


class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String message_text;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if(user!=null){
        loggedInUser = user;
      }
    }
    catch(e){
      print(e);
    }
}
void messageStream() async{
   await for(var snapshot in _firestore.collection('messages').snapshots()){
     for(var message in snapshot.docs){
       print(message.data());
     }
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message_text = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add(
                        {
                          'sender':loggedInUser.email,
                          'text':message_text
                        }
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages  = snapshot.data!.docs.reversed ;
          List<messageBubble> MessageBubbles = [];
          for(var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedInUser.email;

            final MessageBubble = messageBubble(
                sender: messageSender,
                text: messageText,
              isme: currentUser == messageSender,
            );
            MessageBubbles.add(MessageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: MessageBubbles,
            ),
          );
        }
        );
  }
}





class messageBubble extends StatelessWidget {
 final String sender;
 final String text;
 final isme;
  const messageBubble({super.key, required this.sender, required this.text, this.isme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isme? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
        Text(sender,style: TextStyle(
          fontSize: 12,
          color: Colors.black54,
        ),),
          Material
            (
            elevation: 5,
              borderRadius: isme?
              BorderRadius.only(topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))
              :
              BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))

              ,






               color:isme?Colors.white:Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text('$text ',
                style: TextStyle(
                    color: isme?Colors.black:Colors.white,
                    fontSize: 18),),
              )),
        ],
      ),
    );
  }
}

