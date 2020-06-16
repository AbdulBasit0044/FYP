import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speakup/models/student.dart';
//import 'package:speakup/screens/UserSetup/create_account.dart';
import 'package:speakup/screens/home/home.dart';
import 'package:speakup/services/auth.dart';
import 'package:speakup/shared/constants.dart';
import 'package:speakup/shared/loading.dart';

//final studentCollection = Firestore.instance.collection('students');

final CollectionReference studentCollection = Firestore.instance.collection('students');

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({ this.toggleView });



  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

//  bool _isauth = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Student currentStudent;

  String email = '';
  String password= '';
  String error = '';


  /*createUserInFirestore() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;

    //1) check if user exists in users collection in database(according to their id)
    DocumentSnapshot doc = await studentCollection.document(uid).get();

 /*   if(!doc.exists){
    //2) if the user doesn't exist, then we want to take them to the create account page
    final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
    
    //3) get username from create account, use it ti make new user document in users collection
    studentCollection.document(uid).setData({
      "id": uid,
      "username": username,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "displayName": user.displayName,
      });
      doc = await studentCollection.document(uid).get();
    }*/
      currentStudent = Student.fromDocument(doc);
      print(currentStudent);
      print(currentStudent.username);      
        
      await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }*/

  /*Future<bool> _onBackPressed(){
    return showDialog(
      //context: context,
      builder: (context)=>AlertDialog(
        title: Text("Do you really want to exit the app?"),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: ()=>Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: ()=>Navigator.pop(context, true),
          ),
        ],
      )
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
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
        child: Form(
//            onWillPop: _onBackPressed,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Text(
                     'Sign in to SpeakUp',
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
                  decoration: textInputDecoration.copyWith(hintText: 'Enter your password'),
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
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      
//                      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));

//                    createUserInFirestore();


                      if(result == null){
                        setState(() { 
                          error = 'Either email or password is incorrect.';
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
                  }
                ),
                SizedBox(height: 30.0),

                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
          ),
            ),
        ),
      )
    );
  }
}