import 'package:flutter/material.dart';

class AllNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () => Navigator.pushNamed(context, 'Note'),
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
      body: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemCount: 10,
          itemBuilder: (_, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              margin: EdgeInsets.all(20),
              height: 150,
            );
          }),
    );
  }
}
