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

import 'feedPage.dart';
import 'notePage.dart';

class EditNotePage extends StatefulWidget {
  final String uid;
  final String noteKey;
  final String json;
  final bool edit;
  EditNotePage(this.uid, this.noteKey, this.json, this.edit, {Key? key})
      : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  String updatedJson = "";
  Color colorSave = Colors.white;

  DatabaseReference noteRef =
      FirebaseDatabase.instance.reference().child("Notes");

  @override
  void initState() {
    super.initState();
    _loadFromFb();
    if (widget.edit) {
      colorSave = Colors.black45;
    }
  }

  _updateFb(String actualJson) {
    noteRef.child(widget.noteKey).once().then((DataSnapshot snapshot) {
      setState(() {
        if (widget.uid == snapshot.value['uid']) {
          updatedJson = actualJson;
          noteRef.child(widget.noteKey).update({'json': actualJson});
        }
      });
    });
  }

  Future<void> _loadFromFb() async {
    try {
      var myJSON = jsonDecode(widget.json);
      _controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0));
    } catch (e) {
      var myJSON = jsonDecode(updatedJson);
      _controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    // if (_controller == null) {
    //   return Scaffold(
    //       appBar: AppBar(
    //           automaticallyImplyLeading: false,
    //           backgroundColor: Colors.purple,
    //           title: Text(widget.noteKey)));
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Text(widget.noteKey),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                // if (_formKey.currentState!.validate()) {s
                if (!widget.edit) {
                  _updateFb(
                      jsonEncode(_controller.document.toDelta().toJson()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('You successfully edit the note!'),
                      backgroundColor: Colors.green[300]));
                }
              },
              child: Icon(
                Icons.save,
                size: 26.0,
                color: colorSave,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.edit) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedPage(widget.uid)));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotePage(widget.uid)));
                  }
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
        readOnly: widget.edit,
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
          readOnly: widget.edit,
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

  Future<String> _uploadImageToFb(
      BuildContext context, String name, File _imageFile) async {
    String fileName = basename(name);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    // return await (await uploadTask).ref.getDownloadURL();
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image uploded!'), backgroundColor: Colors.green[300]));
      return downloadUrl;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error! This file is not an image'),
          backgroundColor: Colors.red));
      throw ('This file is not an image');
    }
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3 or Firebase) and then return the uploaded image URL
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    ScaffoldMessenger.of(this.context)
        .showSnackBar(SnackBar(content: Text('Wait the upload...')));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    // return copiedFile.path.toString();
    final String imageURL =
        await _uploadImageToFb(this.context, basename(file.path), copiedFile);
    return imageURL;
  }
}
