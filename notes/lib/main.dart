import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:notes/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AllNotes.dart';
import 'Global.dart';
import 'Loading.dart';
import 'Note.dart';
import 'Verify.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String type = getDeviceType();
  if (type == 'phone') {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  String initialRoute = '/';
  if (auth.currentUser != null) {
    initialRoute = 'AllNotes';
  }
  runApp(MaterialApp(
    initialRoute: initialRoute,
    routes: {
      '/': (context) => LoginScreen(),
      'register': (context) => Register(),
      'verify': (context) => Verify(),
      'Note': (context) => Note(),
      'AllNotes': (context) => AllNotes()
    },
    debugShowCheckedModeBanner: false,
  ));
}

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  Future<User> googleSignIn() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential authResult = await auth.signInWithCredential(credential);
    return authResult.user;
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool checkFields() {
      if (_emailController.text == '' || _passwordController.text == '') {
        return false;
      }
      return true;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: SafeArea(
            child: Column(children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        fontFamily: 'SF_Pro_Display',
                        fontSize: 40,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Colors.white),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 20, color: Color(0xFF463A87)),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Colors.white),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 20, color: Color(0xFF463A87)),
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
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          if (checkFields()) {
                            try {
                              showDialog(context: context, child: Loading());
                              await auth.signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              if (auth.currentUser.emailVerified) {
                                Navigator.pop(context);
                                Global.justLogged = true;
                                Navigator.pushNamed((context), 'AllNotes');
                              } else {
                                Navigator.pop(context);
                                Global.justLogged = true;
                                Navigator.pushNamed((context), 'verify');
                              }
                            } catch (e) {
                              Navigator.pop(context);
                              String errorMessage = e.code;

                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text(
                                      "Signing in failed",
                                      style: TextStyle(
                                          fontFamily: 'SF_Pro_Display',
                                          fontSize: 30),
                                    ),
                                    content: Text(
                                      errorMessage,
                                      style: TextStyle(
                                          fontFamily: 'SF', fontSize: 28),
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                                fontFamily: 'SF', fontSize: 26),
                                          ))
                                    ],
                                  ));
                            }
                          } else {
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text(
                                    "Signing in failed",
                                    style: TextStyle(
                                        fontFamily: 'SF_Pro_Display',
                                        fontSize: 30),
                                  ),
                                  content: Text(
                                    "Please fill in all the required fields",
                                    style: TextStyle(
                                        fontFamily: 'SF', fontSize: 26),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              fontFamily: 'SF', fontSize: 26),
                                        ))
                                  ],
                                ));
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontFamily: 'SF_Pro_Display',
                              fontSize: 20,
                              color: Color(0xFF3E75B4)),
                        ))),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: () {},
                      elevation: 2.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/facebook_icon.png'),
                        radius: 20,
                      ),
                      padding: EdgeInsets.all(4.0),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () async {
                        showDialog(context: context, child: Loading());
                        await googleSignIn();
                        if (auth.currentUser != null) {
                          if (auth.currentUser.emailVerified) {
                            Navigator.pop(context);
                            Global.justLogged = true;
                            Navigator.pushNamed((context), 'AllNotes');
                          } else {
                            Navigator.pushNamed(context, 'verify');
                          }
                        }
                      },
                      fillColor: Color(0x00FFFFFF),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/gmail_logo.png'),
                        radius: 20,
                      ),
                      padding: EdgeInsets.all(4.0),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text(
                                "No Sync Over devices",
                                style: TextStyle(
                                    fontFamily: 'SF_Pro_Display', fontSize: 30),
                              ),
                              content: Text(
                                  "If you use this app offline your notes won't be synced to your other devices"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontFamily: 'SF', fontSize: 26),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      Global.useOffline = true;
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, 'AllNotes');
                                    },
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontFamily: 'SF', fontSize: 26),
                                    ))
                              ],
                            ));
                      },
                      fillColor: Color(0x00FFFFFF),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/Unknown.png'),
                        radius: 20,
                      ),
                      padding: EdgeInsets.all(4.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              "Not a user? ",
                              style: TextStyle(
                                  fontFamily: 'SF',
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.zero,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  fontFamily: 'SF_Pro_Display',
                                  fontSize: 24,
                                  color: Color(0xFF3E75B4)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ])));
  }
}
