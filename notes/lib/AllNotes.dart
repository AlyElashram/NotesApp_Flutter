import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes/DataBaseHelper.dart';
import 'Global.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  Future<List> getNotes() async {
    DatabaseHelper db = DatabaseHelper();
    List all = [];
    List<Map<String, dynamic>> data = await db.getNoteMapList();
    data.forEach((element) {
      all.add(element);
    });
    return all;
  }

  void syncToFirebase() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child(uid);
    List onlineData = [];
    DatabaseHelper db = DatabaseHelper();
    try {
      await FirebaseDatabase.instance
          .reference()
          .child(uid)
          .once()
          .then((value) {
        Map<dynamic, dynamic> data = value.value;
        data.forEach((k, v) {
          onlineData.add(v);
        });
      });
    } catch (e) {}

    List<Map<String, dynamic>> data = await db.getNoteMapList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: FlatButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.blue,
            size: 26,
          ),
          onPressed: () {
            if (!Global.useOffline) {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text(
                      "Sign Out",
                      style:
                          TextStyle(fontFamily: 'SF_Pro_Display', fontSize: 30),
                    ),
                    content: Text(
                      "Are you sure you want to sign out?",
                      style: TextStyle(fontFamily: 'SF', fontSize: 28),
                    ),
                    actions: [
                      FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                            FirebaseAuth auth = FirebaseAuth.instance;
                            auth.signOut();
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(fontFamily: 'SF', fontSize: 26),
                          )),
                      FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontFamily: 'SF', fontSize: 26),
                          )),
                    ],
                  ));
            } else {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
        ),
        actions: [
          FlatButton(
            onLongPress: () {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text(
                      "Information",
                      style:
                          TextStyle(fontFamily: 'SF_Pro_Display', fontSize: 30),
                    ),
                    content: Text(
                      "This button fetches all notes from all devices that you are logged in from",
                      style: TextStyle(fontFamily: 'SF', fontSize: 28),
                    ),
                  ));
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.sync_rounded,
              color: Colors.blue,
              size: 26,
            ),
            onPressed: () {},
          ),
          FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.add,
              color: Colors.blue,
              size: 32,
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, 'Note'),
          )
        ],
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> list) {
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: list.hasData ? list.data.length : 0,
              itemBuilder: (_, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete_forever_rounded),
                  ),
                  direction: DismissDirection.endToStart,
                  key: Key(list.data[index]['id'].toString()),
                  onDismissed: (DismissDirection direction) async {
                    DatabaseHelper db = DatabaseHelper();
                    await db.deleteNote(list.data[index]['id']);
                    setState(() {
                      list.data.removeAt(index);
                    });
                  },
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'Note',
                          arguments: {
                            'title': list.data[index]['title'],
                            'body': list.data[index]['body'],
                            'key': list.data[index]['key'],
                            'id': list.data[index]['id']
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.data[index]['title'],
                                style: TextStyle(
                                    fontFamily: 'SF',
                                    color: Colors.blue,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(list.data[index]['body'],
                                  style: TextStyle(
                                      fontFamily: 'SF',
                                      color: Colors.blue,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
