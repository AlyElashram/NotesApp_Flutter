import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes/DataBaseHelper.dart';
import 'package:notes/Loading.dart';
import 'Global.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

//TODO:Delete from firebase
class _AllNotesState extends State<AllNotes> {
  Future<List> getNotes() async {
    if (Global.justLogged && !Global.useOffline) {
      await syncFromFirebase();
      Global.justLogged = false;
    }
    DatabaseHelper db = DatabaseHelper();
    List all = [];
    List<Map<String, dynamic>> data = await db.getNoteMapList();
    data.forEach((element) {
      all.add(element);
    });

    return all;
  }

  Future<void> syncFromFirebase() async {
    DatabaseHelper db = DatabaseHelper();
    List onlineNotes = await pullAndRebase();
    onlineNotes.forEach((element) async {
      await db.deleteNote(element['id']);
      await db.insertNote({
        "title": element['title'],
        "body": element['body'],
        "id": element['id'],
        "key": element["key"]
      });
    });
  }

  Future<List> pullAndRebase() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    List onlineData = [];
    try {
      await FirebaseDatabase.instance
          .reference()
          .child(uid)
          .once()
          .then((value) {
        Map<dynamic, dynamic> online = value.value;

        online.forEach((k, v) {
          onlineData.add(v);
        });
      });
    } catch (e) {
      print(e);
    }
    return onlineData;
  }

  Future<void> syncToFirebase() async {
    if (FirebaseAuth.instance.currentUser != null) {
      List offlineNotes = await getNotes();
      if (offlineNotes != null) {
        offlineNotes.forEach((element) {
          checkKeyandPush(element);
        });
      }
    }
  }

  void checkKeyandPush(Map<String, dynamic> note) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseHelper db = DatabaseHelper();
    if (note['key'] == null) {
      String key = FirebaseDatabase.instance.reference().child(uid).push().key;
      Map<String, dynamic> updatedNote = {
        "title": note['title'],
        "body": note['body'],
        "id": note['id'],
        "key": key
      };
      db.updateNote(updatedNote);
      await FirebaseDatabase.instance
          .reference()
          .child(uid)
          .child(key)
          .update(updatedNote);
    } else {
      Map<String, dynamic> updatedNote = {
        "title": note['title'],
        "body": note['body'],
        "id": note['id'],
        "key": note['key']
      };
      await FirebaseDatabase.instance
          .reference()
          .child(uid)
          .child(note['key'])
          .update(updatedNote);
    }
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
                          onPressed: () async {
                            Navigator.pop(context);
                            showDialog(context: context, child: Loading());
                            await syncToFirebase();
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
            onPressed: () async {
              if (Global.useOffline) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text(
                        "Unable to sync",
                        style: TextStyle(
                            fontFamily: 'SF_Pro_Display', fontSize: 30),
                      ),
                      content: Text(
                        "Syncing is not available when using the app offline\nWould you like to sign in ?",
                        style: TextStyle(fontFamily: 'SF', fontSize: 24),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(fontFamily: 'SF', fontSize: 26),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(fontFamily: 'SF', fontSize: 26),
                            ))
                      ],
                    ));
              } else {
                await syncToFirebase();
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        title: Text('Sync done'),
                      );
                    });
              }
            },
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
                    if (!Global.useOffline &&
                        FirebaseAuth.instance.currentUser != null) {
                      try {
                        await FirebaseDatabase.instance
                            .reference()
                            .child(FirebaseAuth.instance.currentUser.uid)
                            .child(list.data[index]['key'])
                            .remove();
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        list.data.removeAt(index);
                      });
                    }
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
