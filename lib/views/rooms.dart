import 'package:chatter/helper/constants.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/conversation.dart';
import 'package:chatter/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Room extends StatefulWidget {
  final String chatroomId;
  final String chatroomName;
  Room({this.chatroomId, this.chatroomName});
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  TextEditingController message = new TextEditingController();
  Stream channels;
  DBmethods dBmethods = new DBmethods();

  Widget ChatList() {
    return StreamBuilder(
      stream: channels,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData == true
            ? ListView.builder(
                itemCount: snapshot?.data?.data()['roomNames']?.length,
                padding: EdgeInsets.only(top: 50, bottom: 50),
                itemBuilder: (context, index) {
                  return ChannelTile(
                    snapshot?.data?.data()['roomNames'][index],
                    snapshot?.data?.data()['createdBy'],
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
    getChannels();
    Constants.roomName = null;
    super.initState();
  }

  getChannels() async {
    await dBmethods.getChannel(widget.chatroomId).then(
      (value) {
        setState(() {
          channels = value;
        });
      },
    );
  }

  Widget ChannelTile(String channel, String ruler) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      color: Colors.black26,
      child: InkWell(
        onTap: () {
          Constants.roomName = channel;
          Constants.ruler = ruler;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Conversation(
                channelName: Constants.roomName,
                roomId: Constants.serverId,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                channel.toUpperCase(),
                style: GoogleFonts.getFont(
                  'Chelsea Market',
                  fontSize: 22,
                  color: Colors.white,
                ),
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
      body: Stack(
        children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            child: Text(
              'Channels',
              style: GoogleFonts.getFont(
                'Chelsea Market',
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ChatList(),
        ],
      ),
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
              widget.chatroomName,
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
    );
  }
}
