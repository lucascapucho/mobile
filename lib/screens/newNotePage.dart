import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:resumelife/widgets/drawerMenu.dart';
import 'package:tuple/tuple.dart';

import 'notePage.dart';

class NewNotePage extends StatefulWidget {
  final String uid;
  NewNotePage(this.uid, {Key? key}) : super(key: key);

  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString('assets/sample_data.json');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controller = QuillController(
            document: doc, selection: TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Insert your note here...');
      setState(() {
        _controller = QuillController(
            document: doc, selection: TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    if (_controller == null) {
      return Scaffold(body: Center(child: Text('Loading...')));
    }

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        // elevation: .0,
        title: Text('New note'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                jsonEncode(_controller.document.toDelta().toJson());
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
      drawer: DrawerMenu(String, widget.uid),
      body: Container(
        height: height,
        child: Stack(children: <Widget>[
          Center(
            child: BackgroundContainer(),
          ),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {
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

  //Editor area - input
  Widget _buildWelcomeEditor(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: QuillEditor(
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
                      TextStyle(
                        fontSize: 32.0,
                        color: Colors.black,
                        height: 1.15,
                        fontWeight: FontWeight.w300,
                      ),
                      Tuple2(16.0, 0.0),
                      Tuple2(0.0, 0.0),
                      null),
                  sizeSmall: TextStyle(fontSize: 9.0),
                ),
              ),
            ),
          ),
          kIsWeb
              ? Expanded(
                  child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3 or Firebase) and then return the uploaded image URL
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }
}
