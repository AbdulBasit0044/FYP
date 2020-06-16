import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speakup/screens/UserSetup/create_account.dart';
import 'package:speakup/screens/home/home.dart';
import 'package:speakup/services/auth.dart';
import 'package:speakup/shared/constants.dart';
import 'package:speakup/shared/loading.dart';

//final studentCollection = Firestore.instance.collection('students');
final CollectionReference studentCollection = Firestore.instance.collection('students');
final DateTime timestamp = DateTime.now();

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';
 
   createUserInFirestore() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //final uid = user.uid;
    //1) check if user exists in users collection in database(according to their id)
    final DocumentSnapshot doc = await studentCollection.document(user.uid).get();

    if(!doc.exists){
    //2) if the user doesn't exist, then we want to take them to the create account page
    final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
    
    //3) get username from create account, use it ti make new user document in users collection
    studentCollection.document(user.uid).setData({
      "id": user.uid,
      "username": username,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "displayName": user.displayName,
      "timestamp": timestamp
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return loading ? Loading() : Scaffold(
     resizeToAvoidBottomInset: false,
      body: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff000000),
                image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage(
                    "assets/speakup_wallpaper.jpg",
                    ), 
                    fit: BoxFit.fitHeight
                    ),
                  ),
                  alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                

          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                 
                   Text(
                     'Sign Up to SpeakUp',
                     style: TextStyle(
                       fontFamily: "Signatra",
                       fontSize: 80.0,
                       color: Colors.white,
                     ),
                   ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Enter your email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'New password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6 characters long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Confirm new password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6 characters long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        createUserInFirestore();

//                      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));

                        if(result == null){
                          setState(() { 
                            error = 'please enter a valid email';
                            loading = false;
                          });
                        } else {
                          Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
            ),
              ),
          ),
        ),
      )
    );
  }
}