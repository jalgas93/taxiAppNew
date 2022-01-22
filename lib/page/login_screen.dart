import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi/page/main_screen.dart';
import 'package:flutter_taxi/page/registration_screen.dart';
import 'package:flutter_taxi/widgets/progress_dialoge.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Image(
                image: AssetImage('assets/icons/logo.png'),
                width: 390,
                height: 250,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                'Login as Rider',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Brand Bold',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage('Successfull', context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage('Password is mandatory', context);
                        } else {
                          loginAndAuthentificateUser(context);
                        }

                        print('Login clicked');
                        Navigator.pushNamedAndRemoveUntil(
                            context, MapsScreen.idScreen, (route) => false);
                      },
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand Bold'),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  print('Clicked');

                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text('Do not have an Account? Register Here.'),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  void loginAndAuthentificateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialoge(message: 'Authentificating, please wait...');
        });

    final User firebaseUser = (await _fireBaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((value) {
      Navigator.pop(context);
      displayToastMessage('Error:' + value.toString(), context);
    }))
        .user;

    print('jalgasAuth:$firebaseUser');

    if (firebaseUser != null) {
      userRef
          .child(firebaseUser.uid)
          .once()
          .then((value) => (DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MapsScreen.idScreen, (route) => false);
                  displayToastMessage('you are logged in,now', context);
                } else {
                  Navigator.pop(context);
                  _fireBaseAuth.signOut();
                  displayToastMessage(
                      'No records exists for this user,Please create new account',
                      context);
                }
              });

      //save user to database
    } else {
      Navigator.pop(context);
      //error occured - display error msg
      displayToastMessage('Error Occured, can not ', context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
