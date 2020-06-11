import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class chatbotPage extends StatefulWidget {
  @override
  _chatbotPageState createState() => _chatbotPageState();
}

class _chatbotPageState extends State<chatbotPage> {
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/speak-up-gaqiqt-d626f0c8e0e8.json")
            .build();
    print('ok1');
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    print('ok2');
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    print('ok3');
    print(aiResponse.getMessage());
    setState(() {
      messages.insert(0, {"data": 0, "message": aiResponse.getMessage()});
    });
  }

  final messageController = TextEditingController();
  List<Map> messages = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speak Up chat bot"),
        backgroundColor: Colors.pink,
      ),
      body: chatbotWidget(),
    );
  }

  Container chatbotWidget() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => messages[index]['data'] == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(messages[index]["message"].toString()),
                        )
                      : Text(
                          messages[index]["message"].toString(),
                          textAlign: TextAlign.right,
                        )),
            ),
            Divider(
              height: 3.0,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Send your message"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (messageController.text.isEmpty) {
                          print("Messgae is empty");
                        } else {
                          setState(() {
                            messages.insert(0,
                                {"data": 1, "message": messageController.text});
                          });
                          response(messageController.text);
                          messageController.clear();
                        }
                      },
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
