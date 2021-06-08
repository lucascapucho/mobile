import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'signupPage.dart';
import 'notePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void logInToFb() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotePage(result.user!.uid)),
      );
    }).catchError((err) {
      print(err.message);
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
          logInToFb();
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => NotePage()));
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
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _divider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Color(0xfff79c4f),
                  thickness: 1,
                ),
              ),
            ),
            Text(
              'or',
              style: TextStyle(color: Color(0xfff79c4f)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Color(0xfff79c4f),
                  thickness: 1,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ));
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpPage(
                      title: 'Sign Up',
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
              'Don\'t have an account ?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   alignment: Alignment.centerRight,
                    //   child: Text('Forgot Password ?',
                    //       style: TextStyle(
                    //           color: Color(0xfff79c4f),
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500)),
                    // ),
                    _divider(),
                    // _facebookButton(),
                    // FutureBuilder(
                    //     future:
                    //         Authentication.initializeFirebase(context: context),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasError) {
                    //         return Text('Error initializing Firebase');
                    //       } else if (snapshot.connectionState ==
                    //           ConnectionState.done) {
                    //         return GoogleSignInButton();
                    //       }
                    //       return CircularProgressIndicator(
                    //         valueColor: AlwaysStoppedAnimation<Color>(
                    //           Colors.orange,
                    //         ),
                    //       );
                    //     }),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
