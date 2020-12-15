import 'dart:math';

import 'package:chatter/helper/constants.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/conversation.dart';
import 'package:chatter/views/rooms.dart';
import 'package:chatter/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final formKey = GlobalKey<FormState>();
  TextEditingController serverName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool IsLoading = false;
  Random random = Random();

  addNewServer() {
    if (formKey.currentState.validate()) {
      Constants.serverId = serverName.text;
      Map<String, dynamic> serverMap = {
        "createdBy": Constants.name,
        "image":
            "https://avatars.dicebear.com/api/human/${random.nextInt(999999)}.svg",
        "name": serverName.text,
        "users": FieldValue.arrayUnion([Constants.name]),
        "roomNames": FieldValue.arrayUnion([password.text]),
      };
      DBmethods().addServer(serverName.text, serverMap).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Room(
              chatroomId: serverName.text,
              chatroomName: serverName.text,
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    Constants.serverId = null;
    Constants.roomName = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, 'Discord', false),
      body: IsLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
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
                      image: AssetImage('assets/images/welcome8.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                        child: Text(
                          'Create New Server',
                          style: GoogleFonts.getFont(
                            'Chelsea Market',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Fill in the detals'
                                    : value.length > 11
                                        ? 'Enter a name which is less than 11 characters'
                                        : null;
                              },
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              controller: serverName,
                              decoration: textfldDeco('Server Name'),
                            ),
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty
                                    ? 'Fill in the detals'
                                    : value.length > 15
                                        ? 'Enter a name which is less than 15 characters...'
                                        : null;
                              },
                              controller: password,
                              decoration: textfldDeco('Channel Name'),
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                            color: Colors.redAccent,
                            child: Text(
                              'Create new Server',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onPressed: () {
                              addNewServer();
                            },
                          ),
                        ),
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
