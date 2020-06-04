import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:speakup/chatbotPage.dart';
import 'voicebotPage.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future navigateTochatbotPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => chatbotPage()));
  }

  Future navigateTovoicebotPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => voicebotPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speak Up chat bot"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 60.0,
                hoverColor: Colors.green,
                icon: Icon(Icons.chat_bubble),
                onPressed: () {
                  navigateTochatbotPage(context);
                },
              ),
              IconButton(
                iconSize: 60.0,
                hoverColor: Colors.green,
                icon: Icon(Icons.voice_chat),
                onPressed: () {
                  navigateTovoicebotPage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
