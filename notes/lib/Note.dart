import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notes/DatabaseHelper.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference reference = FirebaseDatabase.instance.reference();
  bool oldNote = false;
  int oldID;
  String oldTitle;
  String oldBody;
  String oldKey;
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  void setNote(TextEditingController tit, TextEditingController bod) {
    tit.text = oldTitle;
    tit.selection = TextSelection.fromPosition(
      TextPosition(offset: tit.text.length),
    );
    bod.text = oldBody;
    bod.selection = TextSelection.fromPosition(
      TextPosition(offset: bod.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      Map data = ModalRoute.of(context).settings.arguments;
      oldTitle = data['title'];
      oldBody = data['body'];
      oldKey = data['key'];
      oldID = data['id'];
      oldNote = true;
      setNote(title, body);
    } catch (e) {}
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () async {
              if (title.text != '' || body.text != '') {
                DatabaseHelper db = DatabaseHelper();
                if (!oldNote) {
                  db.insertNote(
                      {db.colTitle: title.text, db.colBody: body.text});
                } else {
                  db.updateNote({
                    db.colTitle: title.text,
                    db.colBody: body.text,
                    db.colKey: oldKey,
                    db.colid: oldID
                  });
                }
              }
              Navigator.pushReplacementNamed(context, 'AllNotes');
            },
          ),
        ),
        body: Column(children: [
          TextField(
            controller: title,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
                hintStyle: TextStyle(
                    fontFamily: 'SF', fontSize: 30, color: Colors.blue)),
            style: TextStyle(
                fontFamily: 'SF',
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: body,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write Your Note here",
                hintStyle: TextStyle(
                    fontFamily: 'SF', fontSize: 30, color: Colors.blue)),
            style: TextStyle(
                fontFamily: 'SF',
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          )
        ]));
  }
}
