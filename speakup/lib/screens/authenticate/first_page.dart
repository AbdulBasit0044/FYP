import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speakup/models/student.dart';
import 'package:speakup/screens/authenticate/register.dart';
import 'package:speakup/screens/authenticate/sign_in.dart';
import 'package:speakup/screens/home/home.dart';
import 'package:speakup/screens/UserSetup/create_account.dart';
import 'package:speakup/shared/loading.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

final usersRef = Firestore.instance.collection('students');
final DateTime timestamp = DateTime.now();
Student currentStudent;

class FirstPage extends StatefulWidget {

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  
  bool isAuth = false;
  bool loading = false;  
  @override

  void initState() {
    super.initState();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    //Reauthenticate user when app is opened
/*    googleSignIn.signInSilently(suppressErrors: false)
      .then((account) {
          handleSignIn(account);
      }).catchError((err) {
        print('Error signing in: $err');
      });*/
  }

  handleSignIn(GoogleSignInAccount account) {
    if(account != null) {
        createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
  }

  createUserInFirestore() async{
    //1) check if user exists in users collection in database(according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if(!doc.exists){
    //2) if the user doesn't exist, then we want to take them to the create account page
    final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
    
    //3) get username from create account, use it ti make new user document in users collection
    usersRef.document(user.id).setData({
      "id": user.id,
      "username": username,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "displayName": user.displayName,
      "timestamp": timestamp
      });
      doc = await usersRef.document(user.id).get();
    }

      currentStudent = Student.fromDocument(doc);
      print(currentStudent);
      print(currentStudent.username);
      
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => Home(),
      ),
    );
  }

  login() async{
     await googleSignIn.signIn();
  }

  Widget build(BuildContext context) {
    return loading ? Loading() : Material(
          type: MaterialType.transparency,
         
          child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(
                  "assets/speakup_wallpaper.jpg",
                  ), 
                  fit: BoxFit.fitHeight
                  ),
                ),
                alignment: Alignment.center,

               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,               
                 children: <Widget>[
                SizedBox(height: 180),                 
                   Text(
                     'SpeakUp',
                     style: TextStyle(
                       fontFamily: "Signatra",
                       fontSize: 90.0,
                       color: Colors.white,
                     ),
                   ),
                   SizedBox(height: 230),
                GestureDetector(
                  onTap: login,
                  child: Container(
                    width: 260.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/signin_google.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                
                GestureDetector(
                  onTap: (){
                  setState(() => loading = true);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  setState(() => loading = false);
                  },
                  child: Container(
                    width: 250.0,
                    height: 55.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/1234.png'),
                        fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                
                GestureDetector(
                  onTap: (){
                    setState(() => loading = true);
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ),
                    );
                    setState(() => loading = false);
                  },                  
                  child: Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                 ]
               ),              
        ),
    );
  }
}