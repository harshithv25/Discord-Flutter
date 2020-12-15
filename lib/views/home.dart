import 'dart:async';

import 'package:chatter/views/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer timer;
  @override
  void initState() {
    new Timer(new Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 31, 35, 1),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Image(
                    image: AssetImage('assets/images/discord2.jpeg'),
                    height: 60,
                    fit: BoxFit.cover,
                    width: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Discord',
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image(
                  image: AssetImage('assets/images/discord3.gif'),
                  height: 40,
                  fit: BoxFit.cover,
                  width: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
