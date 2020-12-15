// ignore: unused_import
import 'package:chatter/helper/authenticate.dart';
import 'package:chatter/helper/constants.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/db.dart';
import 'package:chatter/views/chat.dart';
import 'package:chatter/widget/widget.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String _loggedInUser;
  String _loggedInUserMail;
  String _loggedInUserPhoto;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.email = await HelperFunc.getUserEmail();
    Constants.name = await HelperFunc.getUserName();
    Constants.photoURL = await HelperFunc.getUserImage();
    _loggedInUser = await HelperFunc.getUserName();
    _loggedInUserMail = await HelperFunc.getUserEmail();
    _loggedInUserPhoto = await HelperFunc.getUserImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Center(
          child: _loggedInUser != null
              ? Container(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/welcome2.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Hey ',
                                style: GoogleFonts.getFont(
                                  'Chelsea Market',
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                '${Constants.name}, ',
                                style: GoogleFonts.getFont(
                                  'Chelsea Market',
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${Constants.email}, ',
                            style: GoogleFonts.getFont(
                              'Chelsea Market',
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            width: 250,
                            child: Text(
                              'By proceeding to the app, you will accept to the Terms, Conditions and Rules of the app.....🚀',
                              style: GoogleFonts.getFont(
                                'Chelsea Market',
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.redAccent,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 25, right: 25),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chat(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Proceed',
                                  style: GoogleFonts.getFont(
                                    'Chelsea Market',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/welcome2.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
    );
  }
}
