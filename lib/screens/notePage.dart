import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:resumelife/screens/editNotePage.dart';
import 'package:resumelife/screens/newNotePage.dart';

import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

class NotePage extends StatefulWidget {
  final String uid;
  NotePage(this.uid, {Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  DatabaseReference noteRef =
      FirebaseDatabase.instance.reference().child("Notes");

  _getShareColor(bool share) {
    if (share) {
      return Color(0xfff79c4f);
    } else {
      return Colors.black54;
    }
  }

  _updateShareFb(String title) {
    noteRef.child(title).once().then((DataSnapshot snapshot) {
      setState(() {
        if (widget.uid == snapshot.value["uid"]) {
          if (snapshot.value["public"]) {
            noteRef.child(title).update({"public": false});
          } else {
            noteRef.child(title).update({"public": true});
          }
        }
      });
    });
  }

  _deleteNoteFb(String title) {
    noteRef.child(title).once().then((DataSnapshot snapshot) {
      setState(() {
        if (widget.uid == snapshot.value["uid"]) {
          noteRef.child(title).remove();
        }
      });
    });
  }

  Widget _myCards(BuildContext context) {
    var comments = FirebaseDatabase.instance
        .reference()
        .child("Notes")
        .orderByChild("uid")
        .equalTo(widget.uid)
        .onValue;

    return StreamBuilder(
        stream: comments,
        builder: (context, AsyncSnapshot snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Color(0xfff79c4f),
              );
            default:
              if (snap.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Cannot load or no data!'),
                    backgroundColor: Colors.red));
                return Center(
                  child: Text("Invalid database data!"),
                );
              } else {
                if (snap.hasData && snap.data.snapshot.value != null) {
                  Map data = snap.data.snapshot.value;
                  List item = [];
                  data.forEach(
                      (index, data) => item.add({"key": index, ...data}));

                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: FlutterLogo(size: 72.0),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _deleteNoteFb(item[index]['title']);
                                },
                                icon: Icon(Icons.remove_circle_outline,
                                    color: _getShareColor(false)),
                              ),
                              IconButton(
                                onPressed: () {
                                  _updateShareFb(item[index]['title']);
                                },
                                icon: Icon(Icons.share,
                                    color:
                                        _getShareColor(item[index]['public'])),
                              )
                            ],
                          ),
                          isThreeLine: true,
                          focusColor: Colors.amber,
                          title: Text(item[index]['title']),
                          subtitle: Text(item[index]['date'].substring(0, 10)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditNotePage(
                                        widget.uid,
                                        item[index]["title"],
                                        item[index]["json"])));
                          },
                        ),
                      );
                    },
                  );
                }
              }
          }
          return LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Color(0xfff79c4f),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        // elevation: .0,
        title: Text('My notes'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewNotePage(widget.uid)));
              },
              child: Icon(
                Icons.add_box,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerMenu(String, widget.uid),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          _myCards(context),
        ]),
      ),
    );
  }
}
