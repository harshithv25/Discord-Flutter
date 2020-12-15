import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter/helper/authenticate.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/auth.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/welcome.dart';
import 'package:chatter/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isErr = false;
  AuthServices authServices = new AuthServices();
  DBmethods dBmethods = new DBmethods();
  Random imgAsset = new Random();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  _login() async {
    try {
      await _googleSignIn.signIn().then(
        (value) {
          setState(() {
            isLoading = true;
          });
          HelperFunc.saveUserName(_googleSignIn.currentUser.displayName);
          HelperFunc.saveUserMail(_googleSignIn.currentUser.email);
          HelperFunc.saveUserImage(_googleSignIn.currentUser.photoUrl);
          HelperFunc.saveUserState(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Welcome();
              },
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        isErr = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isErr
              ? Container(
                  margin: EdgeInsets.only(bottom: 30),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Oops something went wrong!',
                          style: GoogleFonts.getFont(
                            'Chelsea Market',
                            color: Colors.white,
                            fontSize: 16.599999999,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Authenticate()));
                            },
                            child: Text(
                              'Back',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        onError: (exception, stackTrace) {
                          setState(() {
                            isLoading = true;
                          });
                        },
                        image: AssetImage(
                            'assets/images/welcome${imgAsset.nextInt(7) + 1}.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF4A4A58),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: ClipRRect(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: Image(
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null)
                                    return Image.asset(
                                      'assets/images/google.png',
                                    );
                                  else
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                },
                                image: AssetImage(
                                  'assets/images/google.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 5,
                            ),
                            color: Colors.amber,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  margin: EdgeInsets.only(right: 15),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4A4A58),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: ClipRRect(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: Image(
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return Image.asset(
                                              'assets/images/google.png',
                                            );
                                          else
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                        },
                                        image: AssetImage(
                                          'assets/images/google.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Sign In with Google',
                                    style: GoogleFonts.getFont(
                                      'Chelsea Market',
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: _login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
