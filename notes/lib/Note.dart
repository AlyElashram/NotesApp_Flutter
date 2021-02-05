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
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  void setNote(TextEditingController tit, TextEditingController bod) {
    tit.text = "";
    tit.selection = TextSelection.fromPosition(
      TextPosition(offset: tit.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    setNote(title, body);
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            splashColor: null,
            highlightColor: null,
            //TODO:Implement on back pressed to save using firebase realtime database
            onPressed: () {
              if (title.text != '' && body.text != '') {
                reference
                    .child(Uid)
                    .push()
                    .set({"title": title.text, "body": body.text});
              }
              Navigator.of(context).pop();
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
