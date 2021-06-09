import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/default_styles.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resumelife/widgets/backgroundContainer.dart';
import 'package:tuple/tuple.dart';

import 'notePage.dart';

class NewNotePage extends StatefulWidget {
  final String uid;
  NewNotePage(this.uid, {Key? key}) : super(key: key);

  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final _formKey = GlobalKey<FormState>();
  DatabaseReference dbNoteRef =
      FirebaseDatabase.instance.reference().child("Notes");

  TextEditingController noteTitleController = TextEditingController();
  late QuillController _controller;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _newDocument();
  }

  @override
  void dispose() {
    super.dispose();
    noteTitleController.dispose();
  }

  void registerToFb(String json) {
    dbNoteRef
        .child(widget.uid)
        .child(
          noteTitleController.text,
        )
        .set({
      "json": json,
      "public": true,
    }).catchError((err) {
      showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid note data!"),
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
        },
      );
    });
  }

  // Create a new document
  Future<void> _newDocument() async {
    final doc = Document()..insert(0, "");
    setState(() {
      _controller = QuillController(
          document: doc, selection: TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // if (_controller == null) {
    //   sleep(const Duration(milliseconds: 40));
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: noteTitleController,
              style: TextStyle(color: Color(0xfff79c4f)),
              decoration: InputDecoration(
                hintText: "Insert your title",
                hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.white),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(25.0),
                //   borderSide: BorderSide(color: Color(0xfff79c4f)),
                // ),
                // labelText: "New note",
                labelStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                // OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "";
                }
                return null;
              },
            )),
        // Text('New note'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  registerToFb(
                      jsonEncode(_controller.document.toDelta().toJson()));
                  showDialog(
                    context: this.context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Note"),
                        content: Text("You successfully saved the note"),
                        actions: [
                          TextButton(
                            child: Text("Continue"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotePage(widget.uid)));
                              // Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotePage(widget.uid)));
                },
                child: Icon(
                  Icons.cancel_rounded,
                  size: 26.0,
                ),
              )),
        ],
      ),
      // drawer: DrawerMenu(String, widget.uid),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.data.isControlPressed && event.character == 'b') {
                if (_controller
                    .getSelectionStyle()
                    .attributes
                    .keys
                    .contains('bold')) {
                  _controller
                      .formatSelection(Attribute.clone(Attribute.bold, null));
                } else {
                  _controller.formatSelection(Attribute.bold);
                }
              }
            },
            child: _buildWelcomeEditor(context),
          ),
        ]),
      ),
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    var quillEditor = QuillEditor(
        controller: _controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Add content',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ));
    if (kIsWeb) {
      quillEditor = QuillEditor(
          controller: _controller,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          customStyles: DefaultStyles(
            h1: DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const Tuple2(16, 0),
                const Tuple2(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ));
      // embedBuilder: defaultEmbedBuilderWeb);
    }
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          kIsWeb
              ? Expanded(
                  child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: QuillToolbar.basic(
                      controller: _controller,
                      onImagePickCallback: _onImagePickCallback),
                ))
              : Container(
                  child: QuillToolbar.basic(
                      controller: _controller,
                      onImagePickCallback: _onImagePickCallback),
                ),
        ],
      ),
    );
  }

  //Editor area - input
  // Widget _buildWelcomeEditor(BuildContext context) {
  //   return SafeArea(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Expanded(
  //           flex: 15,
  //           child: Container(
  //             color: Colors.white,
  //             padding: const EdgeInsets.only(left: 16.0, right: 16.0),
  //             child: QuillEditor(
  //               controller: _controller,
  //               scrollController: ScrollController(),
  //               scrollable: true,
  //               focusNode: _focusNode,
  //               autoFocus: false,
  //               readOnly: false,
  //               placeholder: 'Add content',
  //               expands: false,
  //               padding: EdgeInsets.zero,
  //               customStyles: DefaultStyles(
  //                 h1: DefaultTextBlockStyle(
  //                     TextStyle(
  //                       fontSize: 32.0,
  //                       color: Colors.black,
  //                       height: 1.15,
  //                       fontWeight: FontWeight.w300,
  //                     ),
  //                     Tuple2(16.0, 0.0),
  //                     Tuple2(0.0, 0.0),
  //                     null),
  //                 sizeSmall: TextStyle(fontSize: 9.0),
  //               ),
  //             ),
  //           ),
  //         ),
  //         kIsWeb
  //             ? Expanded(
  //                 child: Container(
  //                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //                 child: QuillToolbar.basic(
  //                     controller: _controller,
  //                     onImagePickCallback: _onImagePickCallback),
  //               ))
  //             : Container(
  //                 child: QuillToolbar.basic(
  //                     controller: _controller,
  //                     onImagePickCallback: _onImagePickCallback),
  //               ),
  //       ],
  //     ),
  //   );
  // }

  Future _uploadImageToFb(
      BuildContext context, String name, File _imageFile) async {
    String fileName = basename(name);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
    uploadTask.then((res) {
      return res.ref.getDownloadURL();
    });
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3 or Firebase) and then return the uploaded image URL
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
    // return _uploadImageToFb(this.context, basename(file.path), copiedFile)
    //     .toString();
  }
}
