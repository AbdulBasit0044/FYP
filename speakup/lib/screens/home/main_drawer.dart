import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speakup/models/student.dart';
import 'package:speakup/screens/Profile/profile.dart';
import 'package:speakup/screens/authenticate/first_page.dart';
import 'package:speakup/screens/authenticate/sign_in.dart';
import 'package:speakup/services/auth.dart';

class MainDrawer extends StatefulWidget {
  final String profileId = currentStudent?.id;


  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  //String profileId = currentStudent?.id;

  final AuthService _auth = AuthService();

  get profileId => currentStudent?.id;

  buildProfileHeader(){
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: usersRef.document(widget.profileId).get(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Text('');
            }
            Student student = Student.fromDocument(snapshot.data);
          
            return Drawer(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 30,
                              bottom: 10,
                              ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(student.photoUrl),
                                  fit: BoxFit.fill
                              )
                            ),
                          ),
                          Text(
                            student.username,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              ),
                            ),
                          Text(
                            student.displayName,
                            style: TextStyle(
                              color: Colors.white,
                              ),
                            ),
                        ]
                      ),
                    )
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => Profile(profileId: profileId),
                        ),
                        );
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onTap: () async{
                      await _auth.signOut();
                      //await googleSignIn.signOut();
                      
                      //firebaseUser = await await _auth.currentUser();
                      
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                      );
                    },
                  ),
                ]
              )
            );
          },
    );    
  }
}