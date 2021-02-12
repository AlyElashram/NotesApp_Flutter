import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(),
          )),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Center(
                    child: Text(
                      "Verify",
                      style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/Email_icon.png'),
                    radius: 70,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: Colors.grey[850]),
                      child: Padding(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Text(
                              "Check Your Email",
                              style: TextStyle(
                                  fontFamily: 'SF',
                                  fontSize: 32,
                                  color: Colors.blue),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                            Text(
                              "A verification email has been sent to ${user.email}. Verify your Email to sync notes across all your devices",
                              maxLines: null,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SF',
                                  fontSize: 22,
                                  color: Colors.grey),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                            Text(
                              "You can use the app offline if you wish not to verify your email ,but syncing notes won't be available",
                              maxLines: null,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'SF',
                                  fontSize: 22,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      Navigator.pushReplacementNamed((context), 'AllNotes');
      timer.cancel();
    }
  }
}
