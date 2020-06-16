import 'package:flutter/material.dart';
import 'package:speakup/screens/home/main_drawer.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:speakup/chatbotPage.dart';
import 'package:speakup/voicebotPage.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Material(
          type: MaterialType.transparency,

          child: Scaffold(
//          backgroundColor: Colors.brown[50],
          
          appBar: AppBar(
          title: Text("SpeakUp",
          style: TextStyle(
                fontFamily: "MetalMania",
                fontSize: 35.0,
                color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.pink,
        ),

          body: Container(
          decoration: BoxDecoration(
            color: const Color(0xff000000),
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),

              image: AssetImage('assets/Public Speaking.jpg'),
              fit: BoxFit.fitHeight,
              //colorFilter: ColorFilter.linearToSrgbGamma(),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to SpeakUp',
                  style: TextStyle(                  
                    fontFamily: "Signatra",
                    fontSize: 80.0,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
//                    color: Colors.white,
                  ),
                textAlign: TextAlign.center,
                ),

                SizedBox(height: 60.0),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 40.0),
                    IconButton(
                      iconSize: 70.0,
                      icon: Image.asset('assets/image.png'),
                      hoverColor: Colors.green,
                      onPressed: () {
                        navigateTochatbotPage(context);
                      },
                    ),
                    SizedBox(width: 30.0),                    
                    IconButton(
                      iconSize: 120.0,
                      icon: Image.asset('assets/voicebot.png'),
                      hoverColor: Colors.green,
                      onPressed: () {
                        navigateTovoicebotPage(context);
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 66),
                    Text('ChatBot',
                      style: TextStyle(
                      fontFamily: "MetalMania",
                      fontSize: 30.0,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
                      //color: Colors.blue[100],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 50),
                  Text('VoiceBot',
                      style: TextStyle(
                      fontFamily: "MetalMania",
                      fontSize: 30.0,
                      color: Color.fromRGBO(255, 255, 255, 0.7),
//                      color: Colors.blue[100],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: MainDrawer(),
      ),
    );
  }
}