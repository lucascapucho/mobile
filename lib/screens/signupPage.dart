import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'loginPage.dart';
import 'notePage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void registerToFb() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user!.uid).set({
        "username": userNameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      }).then((res) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotePage(result.user!.uid)),
        );
      });
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Insert a correct data!"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Continue"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  Widget _entryField(String title, TextInputType keyboardType,
      TextEditingController controller, String field,
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
            autofocus: true,
            controller: controller,
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
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter a correct " + field;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            registerToFb();
          }
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => LoginPage(
          //               title: 'Sign In',
          //             )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              // boxShadow: <BoxShadow>[
              //   BoxShadow(
              //       color: Color(0xfffbb448),
              //       offset: Offset(1, 2),
              //       blurRadius: 5,
              //       spreadRadius: .5)
              // ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      title: 'Sign In',
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Res',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'u',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'me',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(
            "Username", TextInputType.name, userNameController, "Username"),
        _entryField(
            "Email", TextInputType.emailAddress, emailController, "Email"),
        _entryField(
            "Password", TextInputType.multiline, passwordController, "Password",
            isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Center(
              child: BackgroundContainer(),
            ),
            // Positioned(
            //   top: -MediaQuery.of(context).size.height * .15,
            //   right: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainer(),
            // ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      SizedBox(height: height * .14),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
