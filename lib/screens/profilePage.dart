import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:resumelife/screens/notePage.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:resumelife/widgets/drawerMenu.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage(this.uid, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotePage(widget.uid)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Save',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _entryField(String title, TextInputType keyboardType,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: keyboardType,
            style: TextStyle(color: Color(0xfff79c4f)),
            obscureText: isPassword,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Color(0xfff79c4f)),
              ),
              labelText: title,
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileEntries() {
    return Column(
      children: <Widget>[
        _entryField("Username", TextInputType.name),
        _entryField("Email", TextInputType.emailAddress),
        _entryField("Password", TextInputType.multiline, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Profile'),
      ),
      drawer: DrawerMenu(String, widget.uid),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Center(
              child: BackgroundContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _profilePicture(),
                    _profileEntries(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePicture() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(.0, 15.0, .0, .0),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 50.0,
                  ),
                ),
              ),
              Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        // Color(0xfff79c4f),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
