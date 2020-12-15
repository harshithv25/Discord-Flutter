import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter/helper/constants.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/chat.dart';
import 'package:chatter/views/rooms.dart';
import 'package:chatter/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DBmethods dBmethods = new DBmethods();
  TextEditingController userName = new TextEditingController();
  Stream rooms;
  bool isLoading = false;
  String userEmail;

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
                    snapshot.data.documents[index]
                        .data()['users']
                        .contains(Constants.name),
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

  Widget RoomTile(
      String roomName, String roomId, String imageURL, bool isJoined) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
                      Container(
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Text(
                          roomName.toUpperCase(),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.getFont(
                            'Chelsea Market',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  RaisedButton(
                    onPressed: isJoined
                        ? null
                        : () {
                            setState(() {
                              isLoading = true;
                            });
                            dBmethods
                                .addUser(Constants.name, roomId)
                                .then((value) {
                              Constants.serverId = roomId;
                              Constants.roomName = null;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Room(
                                    chatroomId: roomId,
                                    chatroomName: roomName,
                                  ),
                                ),
                              );
                            });
                          },
                    child: Text(
                      isJoined ? 'Joined' : 'Join',
                      style: GoogleFonts.getFont(
                        'Chelsea Market',
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.redAccent,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Constants.serverId = null;
    Constants.roomName = null;
    getAllrooms();
    super.initState();
  }

  getAllrooms() async {
    DBmethods().getAllRooms().then((value) {
      setState(() {
        rooms = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orangeAccent.shade400,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.asset(
                      'assets/images/discord.jpeg',
                      height: 40,
                    ),
                  ),
                  Text(
                    'Discord',
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            body: RoomList(),
          );
  }
}
