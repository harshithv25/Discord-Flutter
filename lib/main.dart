import 'package:chatter/helper/authenticate.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/views/chat.dart';
import 'package:chatter/views/home.dart';
import 'package:chatter/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  bool isLogged = false;
  void initState() {
    getState();
    super.initState();
  }

  getState() async {
    await HelperFunc.getUserState().then((value) {
      setState(() {
        isLogged = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff1f1f1f),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLogged == true ? Home() : Authenticate(),
    );
  }
}
