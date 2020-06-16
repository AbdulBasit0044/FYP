import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_tts/flutter_tts.dart';

const languages = const [
  const Languages('English', 'en_US'),
];

class Languages {
  final String name;
  final String code;

  const Languages(this.name, this.code);
}

class voicebotPage extends StatefulWidget {
  @override
  _voicebotPageState createState() => _voicebotPageState();
}

class _voicebotPageState extends State<voicebotPage> {
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
    aiReply = aiResponse.getMessage();
    speak();
    setState(() {
      messages.insert(0, {"data": 0, "message": aiResponse.getMessage()});
    });
  }

  final messageController = TextEditingController();
  List<Map> messages = List();
  String aiReply = "";

  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  Languages selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('en_US').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  FlutterTts flutterTts = new FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SpeakUp VoiceBot",
            style: TextStyle(                  
            fontFamily: "MetalMania",
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.pink.shade100,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 100.0, 10.0, 0.0),
                  child: new Text(
                    transcription,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.pink.shade100,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 100.0, 10.0, 0.0),
                  child: new Text(
                    aiReply,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: 75.0,
                        width: 75.0,
                        child: FloatingActionButton(
                          heroTag: null,
                          mini: true,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.cancel,
                            size: 30.0,
                          ),
                          onPressed: _isListening ? () => cancel() : null,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        height: 75.0,
                        width: 75.0,
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.mic,
                            size: 30.0,
                          ),
                          onPressed:
                              _speechRecognitionAvailable && !_isListening
                                  ? () => start()
                                  : null,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.stop,
                            size: 30.0,
                          ),
                          mini: true,
                          onPressed: _isListening ? () => stop() : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CheckedPopupMenuItem<Languages>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Languages>(
            value: l,
            checked: selectedLang == l,
            child: new Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Languages lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed, Icon icon}) =>
      new Padding(
          padding: new EdgeInsets.all(12.0),
          child: new RaisedButton(
            color: Colors.cyan.shade600,
            onPressed: onPressed,
            child: new Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ));

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() {
      _isListening = false;
      response(transcription);
    });
  }

  void errorHandler() => activateSpeechRecognizer();

  speak() async {
    flutterTts.speak(aiReply);
  }
}
