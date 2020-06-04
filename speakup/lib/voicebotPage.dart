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
    callSpeak();
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
        title: Text("Speak Up chat bot"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            new Expanded(
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.yellow.shade200,
                child: new Text(transcription),
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Container(
                color: Colors.orange.shade100,
                child: new Text(aiReply),
              ),
            ),
            Expanded(
              child: RaisedButton(
                //onPressed: speak,
                child: new Text('Say Hello'),
              ),
            ),
            _buildButton(
              onPressed: _speechRecognitionAvailable && !_isListening
                  ? () => start()
                  : null,
              label: _isListening
                  ? 'Listening...'
                  : 'Listen (${selectedLang.code})',
            ),
            _buildButton(
              onPressed: _isListening ? () => cancel() : null,
              label: 'Cancel',
            ),
            _buildButton(
              onPressed: _isListening ? () => stop() : null,
              label: 'Stop',
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

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
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
    });
  }

  void errorHandler() {
    activateSpeechRecognizer();
  }

  void callSpeak() {
    response(transcription);
  }

  speak() async {
    flutterTts.speak(aiReply);
  }
}
