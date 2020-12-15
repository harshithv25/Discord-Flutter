import 'package:chatter/views/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatter/helper/constants.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/widget/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Conversation extends StatefulWidget {
  final String roomId;
  final String channelName;
  Conversation({this.roomId, this.channelName});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController message = new TextEditingController();
  Stream messages;
  Stream members;
  final formKey = GlobalKey<FormState>();
  DocumentSnapshot snapshot;
  bool isLoading = false;
  DateTime dateTime;
  DBmethods dBmethods = new DBmethods();
  ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController?.jumpTo(
        _scrollController?.position?.maxScrollExtent,
      );
    }
  }

  sendMsg() {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": message.text,
        "name": Constants.name,
        "timestamp": FieldValue.serverTimestamp(),
        "userURL": Constants.photoURL
      };
      dBmethods.addMessage(widget.roomId, widget.channelName, messageMap);
      message.text = '';
    }
  }

  Widget ChatList() {
    return StreamBuilder(
      stream: messages,
      builder: (BuildContext context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  return MessageTile(
                    snapshot.data.documents[index].data()['message'],
                    Constants.name ==
                            snapshot.data.documents[index].data()['name']
                        ? true
                        : false,
                    snapshot.data.documents[index].data()['name'],
                    snapshot.data.documents[index].data()['timestamp'].toDate(),
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

  Widget MemberList() {
    return StreamBuilder(
      stream: members,
      builder: (BuildContext context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.data()['users'].length,
                padding: EdgeInsets.only(bottom: 10),
                itemBuilder: (context, index) {
                  Constants.ruler = snapshot.data.data()['createdBy'];
                  return MemberTile(
                    snapshot?.data?.data()['users'][index],
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
    dBmethods.getChannel(Constants.serverId).then((value) {
      setState(() {
        members = value;
      });
    });
    dBmethods
        .getChannelMsgs(widget.channelName, widget.roomId)
        .then((snapshots) {
      setState(() {
        messages = snapshots;
      });
    });
    super.initState();
  }

  Widget MemberTile(String member, String ruler) {
    Constants.ruler = ruler;
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, bottom: 5, right: 0),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        splashColor: Colors.orange,
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (member == Constants.name)
                  ? Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        "$member - You",
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.getFont(
                          'Chelsea Market',
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : member == Constants.ruler
                      ? Container(
                          constraints: BoxConstraints(maxWidth: 250),
                          child: Text(
                            "$member - Admin",
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.getFont(
                              'Chelsea Market',
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Container(
                          constraints: BoxConstraints(maxWidth: 250),
                          child: Text(
                            "$member",
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.getFont(
                              'Chelsea Market',
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MessageTile(String message, final bool sentByAppUser, String sentBy,
      dynamic timestamp) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      alignment: sentByAppUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            !sentByAppUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: !sentByAppUser
                ? EdgeInsets.only(left: 15)
                : EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: !sentByAppUser
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Text(
                  sentBy,
                  style: GoogleFonts.getFont(
                    'Chelsea Market',
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 26),
            decoration: BoxDecoration(
                gradient: sentByAppUser
                    ? LinearGradient(
                        colors: [
                          const Color.fromRGBO(255, 153, 0, 1),
                          const Color.fromRGBO(255, 145, 0, 1),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          const Color(0x1AFFFFFF),
                          const Color(0x1AFFFFFF)
                        ],
                      ),
                borderRadius: sentByAppUser
                    ? BorderRadius.only(
                        topLeft: Radius.circular(500),
                        bottomLeft: Radius.circular(500),
                        topRight: Radius.circular(500),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(500),
                        bottomRight: Radius.circular(500),
                        topRight: Radius.circular(500),
                      )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 270),
                  child: Text(
                    message,
                    maxLines: 10,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.getFont(
                      'Chelsea Market',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            drawerEnableOpenDragGesture: true,
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
                            padding: EdgeInsets.all(5),
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
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null)
                                      return Image.network(
                                        Constants.photoURL,
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
                                  image: NetworkImage(
                                    Constants.photoURL,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${Constants.name.substring(0, Constants.name.lastIndexOf(' '))},",
                            style: GoogleFonts.getFont(
                              'Chelsea Market',
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${Constants.email}",
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
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1),
                      ),
                    ),
                    child: Text(
                      'Channel Members',
                      style: GoogleFonts.getFont(
                        'Chelsea Market',
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  MemberList(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2),
                      ),
                    ),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      disabledColor: Colors.black38,
                      onPressed: Constants.name == Constants.ruler
                          ? null
                          : () {
                              setState(() {
                                isLoading = true;
                              });
                              dBmethods
                                  .leaveServer(
                                      Constants.serverId, Constants.name)
                                  .then(
                                (value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chat(),
                                    ),
                                  );
                                },
                              );
                            },
                      color: Colors.redAccent,
                      child: Text(
                        'Leave Server',
                        style: GoogleFonts.getFont(
                          'Chelsea Market',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
            body: Container(
              child: Stack(
                children: [
                  ChatList(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.grey,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: message,
                              decoration: InputDecoration(
                                hintText: 'Type a message.......',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.getFont('Chelsea Market',
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            child: FloatingActionButton(
                              tooltip: 'Send',
                              backgroundColor: Colors.orange,
                              onPressed: () {
                                sendMsg();
                              },
                              child: Icon(Icons.send),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
