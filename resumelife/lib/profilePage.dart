import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resumelife/Widget/backgroundContainer.dart';
import 'package:resumelife/notePage.dart';

import 'Widget/drawerMenu.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotePage()));
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

  Widget _profileWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", TextInputType.name),
        _entryField("Email", TextInputType.emailAddress),
        _entryField("Description", TextInputType.multiline),
        _entryField("Password", TextInputType.multiline, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // elevation: .0,
        title: Text('Profile details'),
      ),
      drawer: DrawerMenu(),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Center(
              child: BackgroundContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    _profileWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    profileView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(.0, 100.0, 30.0, .0),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 70.0,
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
                        color: Color(0xfff79c4f),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
