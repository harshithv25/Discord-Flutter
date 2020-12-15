// ignore: unused_import
import 'package:chatter/helper/authenticate.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/auth.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/welcome.dart';
import 'package:chatter/widget/widget.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  final Function toggleScreen;
  SignUp(this.toggleScreen);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool isErr = false;
  AuthServices authServices = new AuthServices();
  DBmethods dBmethods = new DBmethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'userName': userName.text,
        'email': email.text,
      };
      setState(() {
        isLoading = true;
      });
      authServices.signUpEP(email.text, password.text).then((value) {
        if (value != null) {
          HelperFunc.saveUserMail(email.text);
          HelperFunc.saveUserName(userName.text);
          HelperFunc.saveUserState(true);
          dBmethods.uploadUserInfo(userInfoMap, value.userId);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Welcome()));
        } else if (value == null) {
          setState(() {
            isLoading = false;
            isErr = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : isErr
              ? Container(
                  padding: EdgeInsets.all(60),
                  margin: EdgeInsets.only(bottom: 30),
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'The email already exists!',
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
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Please fill in the detals'
                                        : value.length < 4
                                            ? 'Uh! I haven\'t seen a name less than 6 characters long'
                                            : null;
                                  },
                                  controller: userName,
                                  decoration: textfldDeco('Username'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Please fill in the detals'
                                        : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(value)
                                            ? null
                                            : 'Please provide a valid email';
                                  },
                                  controller: email,
                                  decoration: textfldDeco('Email'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (value) {
                                    return value.isEmpty
                                        ? 'Please fill in the detals'
                                        : value.length < 6
                                            ? 'Please Enter a password which is more than 6 chars long'
                                            : null;
                                  },
                                  controller: password,
                                  decoration: textfldDeco('Password'),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.redAccent,
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.getFont(
                                    'Chelsea Market',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: signMeUp,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.blue,
                                child: Text(
                                  'Sign In with Google',
                                  style: GoogleFonts.getFont(
                                    'Chelsea Market',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: () => print(''),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleScreen();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
