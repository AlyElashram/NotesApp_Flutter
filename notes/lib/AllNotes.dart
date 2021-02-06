import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AllNotes extends StatefulWidget {
  @override
  _AllNotesState createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  Future<List> getNotes() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    List all = [];
    // ignore: unnecessary_statements

    await FirebaseDatabase.instance.reference().child(uid).once().then((value) {
      Map<dynamic, dynamic> data = value.value;
      data.forEach((k, v) {
        all.add(v);
      });
    });
    return all;
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference refrence =
        FirebaseDatabase.instance.reference().child(uid);
    Future<List> allNotes = getNotes();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          actions: [
            FlatButton(
              child: Icon(
                Icons.add,
                color: Colors.blue,
                size: 32,
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, 'Note'),
            )
          ],
          backgroundColor: Colors.grey[900],
          leading: FlatButton(
              splashColor: null,
              highlightColor: null,
              onPressed: () {
                //TODO:This will log you out Dialog
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.blue))),
      body: FutureBuilder(
        future: getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> list) {
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              itemCount: list.hasData ? list.data.length : 0,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'Note', arguments: {
                      'title': list.data[index]['title'],
                      'body': list.data[index]['body']
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    margin: EdgeInsets.all(20),
                    height: 150,
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
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(list.data[index]['body'],
                              style: TextStyle(
                                  fontFamily: 'SF',
                                  color: Colors.blue,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))
                        ],
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
