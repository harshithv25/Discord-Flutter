import 'package:chatter/helper/authenticate.dart';
import 'package:chatter/helper/constants.dart';
import 'package:chatter/helper/helper.dart';
import 'package:chatter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.orangeAccent.shade400,
    title: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
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
        )),
  );
}

Widget mainAppBar(BuildContext context, String roomName, bool isMain) {
  return AppBar(
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
    actions: [
      isMain
          ? GestureDetector(
              child: Container(
                padding: EdgeInsets.only(right: 15),
                child: FloatingActionButton(
                  heroTag: 'Logout_btn',
                  backgroundColor: Colors.deepOrange,
                  tooltip: 'Logout',
                  child: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    AuthServices authServices = new AuthServices();
                    Constants.email = '';
                    Constants.name = '';
                    Constants.photoURL = '';
                    Constants.roomName = null;
                    Constants.serverId = null;
                    Constants.ruler = null;
                    await HelperFunc.saveUserImage(null);
                    await HelperFunc.saveUserMail(null);
                    await HelperFunc.saveUserName(null);
                    await HelperFunc.saveUserState(false);
                    authServices.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authenticate(),
                      ),
                    );
                  },
                ),
              ),
            )
          : Container(),
    ],
  );
}

InputDecoration textfldDeco(hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white60,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white10,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}
