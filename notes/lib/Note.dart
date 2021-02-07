import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  String Uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference reference = FirebaseDatabase.instance.reference();
  bool oldNote = false;
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
            //TODO:Implement on back pressed to save using firebase realtime database
            onPressed: () {
              if (title.text != '' || body.text != '') {
                if (!oldNote) {
                  String key = reference.child(Uid).push().key;
                  reference.child(Uid).child(key).set(
                      {"title": title.text, "body": body.text, "key": key});
                } else {
                  reference.child(Uid).child(oldKey).update(
                      {"title": title.text, "body": body.text, "key": oldKey});
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
