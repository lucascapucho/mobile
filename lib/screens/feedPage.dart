import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

import 'editNotePage.dart';

class FeedPage extends StatefulWidget {
  final String uid;
  FeedPage(this.uid, {Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  DatabaseReference noteRef =
      FirebaseDatabase.instance.reference().child("Notes");

  _getShareColor(bool share) {
    if (share) {
      return Color(0xfff79c4f);
    } else {
      return Colors.black54;
    }
  }

  Widget _myCards(BuildContext context) {
    var comments = FirebaseDatabase.instance
        .reference()
        .child("Notes")
        .orderByChild("public")
        .equalTo(true)
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
                          trailing: Icon(Icons.share,
                              color: _getShareColor(item[index]['public'])),
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
                                        item[index]["json"],
                                        true)));
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
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Global notes'),
      ),
      drawer: DrawerMenu(String, widget.uid),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, .0),
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff79c4f),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  suffixIcon: Icon(Icons.search, color: Color(0xfff79c4f)),
                  border: InputBorder.none,
                  hintText: 'Search here...',
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          ),
          _myCards(context)
        ]),
      ),
    );
  }
}
