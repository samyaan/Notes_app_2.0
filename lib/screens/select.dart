import 'package:flutter/material.dart';
import 'package:notes_app/screens/note_list.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notes', style: Theme.of(context).textTheme.headline1),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.red,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              textColor: Colors.blue,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
              },
            child: Center(
              child: Center(child: Text('Personal')),
            ),
            ),
            SizedBox(
              width: 15.0,
              child: Text('|'),
            ),
            FlatButton(
              textColor: Colors.blue,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
              },
              child: Center(
                child: Text('Official'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}



