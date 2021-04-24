import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar.dart';

import 'backgroundContainer.dart';

typedef DemoContentBuilder = Widget Function(
    BuildContext context, QuillController controller);

// Common scaffold for all examples.
class DemoScaffold extends StatefulWidget {
  /// Filename of the document to load into the editor.
  final String documentFilename;
  final DemoContentBuilder builder;
  final List<Widget> actions;
  final bool showToolbar;

  const DemoScaffold({
    Key? key,
    required this.documentFilename,
    required this.builder,
    required this.actions,
    required this.showToolbar,
  }) : super(key: key);

  @override
  _DemoScaffoldState createState() => _DemoScaffoldState();
}

class _DemoScaffoldState extends State<DemoScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late QuillController _controller;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null && !_loading) {
      _loading = true;
      _loadFromAssets();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result =
          await rootBundle.loadString('assets/${widget.documentFilename}');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controller = QuillController(
            document: doc, selection: TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    } catch (error) {
      final doc = Document()
        ..insert(0,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean aliquam magna sed dictum finibus. Fusce lectus urna, consequat id risus finibus, tempor tempor massa. Sed nibh nisl, sodales in neque et, tempor euismod tellus. Aenean tristique turpis ut rutrum faucibus. Nunc id urna eu quam dapibus iaculis. Duis imperdiet molestie enim at porttitor. Aenean pulvinar rhoncus pulvinar. Ut imperdiet quam dui, tempus laoreet arcu faucibus malesuada. Vestibulum ut sodales quam. Quisque sed dictum metus. Curabitur metus eros, facilisis ac est sed, mollis facilisis erat. In tristique magna id maximus accumsan.");
      setState(() {
        _controller = QuillController(
            document: doc, selection: TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: _loading || widget.showToolbar == false
            ? null
            : QuillToolbar.basic(controller: _controller),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                jsonEncode(_controller.document.toDelta().toJson());
              },
              child: Icon(
                Icons.favorite,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.share,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: BackgroundContainer(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5.0, 89.0, 5.0, .0),
              child: _loading
                  ? Center(child: Text('Loading...'))
                  : widget.builder(context, _controller),
            ),
          ],
        ),
      ),
    );
  }
}
