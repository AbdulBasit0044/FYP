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
      drawer: Drawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/img1.jpg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 130.0,
                icon: Image.asset('assets/chatbot.png'),
                hoverColor: Colors.green,
                onPressed: () {
                  navigateTochatbotPage(context);
                },
              ),
              IconButton(
                iconSize: 200.0,
                icon: Image.asset('assets/voicebot.png'),
                hoverColor: Colors.green,
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
