import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/screens/note_list.dart';

class Stt extends StatelessWidget {
   Note note;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(this.note),
    );
  }
}

class VoiceHome extends StatefulWidget {
  final Note note;

  VoiceHome(this.note);
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int color;
  bool isEdited = false;
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FloatingActionButton(
                  heroTag: Text("btn1"),
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.cancel().then(
                            (result) => setState(() {
                          _isListening = result;
                          resultText = "";
                        }),
                      );
                  },
                ),
                new FloatingActionButton(
                  heroTag: Text("btn2"),
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                      _speechRecognition
                          .listen(locale: "en_US")
                          .then((result) => print('$result'));
                  },
                  backgroundColor: Colors.pink,
                ),
                new FloatingActionButton(
                  heroTag: Text("btn3"),
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    if (_isListening)
                      _speechRecognition.stop().then(
                            (result) => setState(() => _isListening = result),
                      );
                  },
                ),
                new FloatingActionButton(
                  heroTag: Text("btn4"),
                  child: Icon(Icons.save),
                  mini: false,
                  backgroundColor: Colors.green,
                  onPressed: () {
                      _save();
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),

              ),
            )
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
  }

  void _save() async {
    moveToLastScreen();
    updateTitle();
    updateDescription();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

  void updateTitle() {

    note.title = 'Voice_Note';
  }

  void updateDescription() {
    isEdited = true;
    note.description = resultText;
  }
}


