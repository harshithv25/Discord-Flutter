import 'dart:math';

import 'package:chatter/views/add.dart';
import 'package:chatter/helper/constants.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/rooms.dart';
import 'package:chatter/views/search.dart';
import 'package:chatter/widget/widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream rooms;
  String imgAssetImg;
  Random imgAsset = new Random();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Widget RoomList() {
    return StreamBuilder(
      stream: rooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return RoomTile(
                    snapshot.data.documents[index].data()['name'],
                    snapshot.data.documents[index].id,
                    snapshot.data.documents[index].data()['image'],
                  );
                },
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    Constants.ruler = null;
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.email = await HelperFunc.getUserEmail();
    Constants.name = await HelperFunc.getUserName();
    Constants.photoURL = await HelperFunc.getUserImage();
    DBmethods().getRooms(Constants.name).then((value) {
      setState(() {
        rooms = value;
      });
    });
  }

  Widget RoomTile(String roomName, String roomId, String imageURL) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: () {
          Constants.serverId = roomId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Room(
                chatroomId: Constants.serverId,
                chatroomName: roomName,
              ),
            ),
          );
        },
        child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageURL),
                  backgroundColor: Colors.orange,
                  child: Text(
                    roomName.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName.toUpperCase(),
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.deepOrange,
                      Colors.orangeAccent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      height: 90,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A4A58),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: ClipRRect(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: Image(
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null)
                                return Image.network(
                                  Constants.photoURL,
                                );
                              else
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                            },
                            image: NetworkImage(
                              Constants.photoURL,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${Constants?.name},",
                      style: GoogleFonts?.getFont(
                        'Chelsea Market',
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${Constants?.email}",
                      style: GoogleFonts.getFont(
                        'Chelsea Market',
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.orange,
              child: ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Proflile',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.orange,
              child: ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Chats',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.orange,
              child: ListTile(
                title: Container(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monetization_on),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Purchases',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              splashColor: Colors.orange,
              child: ListTile(
                title: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Sign out',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: mainAppBar(context, 'Discord', true),
      body: RoomList(),
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                heroTag: 'Search_btn',
                backgroundColor: Colors.orangeAccent.shade400,
                tooltip: 'Explore servers',
                child: Icon(Icons.explore),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search()),
                  );
                },
              ),
            ),
            Container(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Add()),
                  );
                },
                heroTag: 'Add_new',
                tooltip: 'Add a server',
                backgroundColor: Colors.orangeAccent.shade400,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
