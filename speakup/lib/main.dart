import 'package:flutter/material.dart';
import 'package:speakup/screens/authenticate/first_page.dart';
//import 'package:speakup/screens/authenticate/sign_in_with_google.dart';
//import 'package:speakup/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:speakup/services/auth.dart';
import 'package:speakup/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.yellow[600],
        ),
        //home: Wrapper(),
        home: FirstPage(),
      ),
    );
  }
}
