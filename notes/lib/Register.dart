import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _conpassController = TextEditingController();

  Future<void> showMyDialog(
      {BuildContext context, String title, String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: 300,
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            backgroundColor: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('Assests/Wrong.png'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'SF_Pro_Display',
                          fontSize: 22,
                          color: Color(0xFF3E395A)),
                    )
                  ],
                ),
                Text(
                  body,
                  style: TextStyle(fontFamily: 'SF_Pro_Display', fontSize: 22),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  int checkFields() {
    if (_emailController.text == '' ||
        _passController.text == '' ||
        _conpassController.text == '') {
      return 1;
    } else if (_conpassController.text == _passController.text) {
      return 0;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text("Register",
                            style: TextStyle(
                                fontFamily: 'SF_Pro_Display',
                                fontSize: 40,
                                color: Colors.white)),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              color: Colors.white),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 20, color: Color(0xFF463A87)),
                              contentPadding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                              hintText: "Email",
                              icon: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Icon(
                                    Icons.email_rounded,
                                    color: Color(0xFF3E75B4),
                                  )),
                            ),
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'SF_Pro_Display',
                                color: Color(0xFF463A87)),
                          ),
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            color: Colors.white),
                        child: TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20, color: Color(0xFF463A87)),
                            contentPadding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                            hintText: "Password",
                            icon: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.vpn_key_rounded,
                                  color: Color(0xFF3E75B4),
                                )),
                          ),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SF_Pro_Display',
                              color: Color(0xFF463A87)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            color: Colors.white),
                        child: TextField(
                          controller: _conpassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20, color: Color(0xFF463A87)),
                            contentPadding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                            hintText: "Confirm Password",
                            icon: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.vpn_key_rounded,
                                  color: Color(0xFF3E75B4),
                                )),
                          ),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SF_Pro_Display',
                              color: Color(0xFF463A87)),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              int checkParam = checkFields();
                              if (checkParam == 0) {
                                try {
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: _emailController.text,
                                              password: _passController.text);
                                  Navigator.pushReplacementNamed(
                                      (context), '/');
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    //TODO: pop up Dialogue for message
                                    print('The password provided is too weak.');
                                  } else if (e.code == 'email-already-in-use') {
                                    print(
                                        'The account already exists for that email.');
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else if (checkParam == 1) {
                                showMyDialog(
                                    context: context,
                                    title: "Missing Information",
                                    body:
                                        "Please Fill in the missing information");
                              } else if (checkParam == 2) {
                                showMyDialog(
                                    context: context,
                                    title: "Mismatch",
                                    body: "Passwords do not match");
                              }
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  fontFamily: 'SF_Pro_Display',
                                  fontSize: 20,
                                  color: Color(0xFF3E75B4)),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
