import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
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
            onPressed: null,
            color: Colors.blue,
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
