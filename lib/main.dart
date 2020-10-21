import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:text_editor/text_editor.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TextOverImage(),
  ));
}

class TextOverImage extends StatefulWidget {
  bool textBorder = false;

  @override
  _TextOverImageState createState() => _TextOverImageState();
}

class _TextOverImageState extends State<TextOverImage> {
  File _imageFile;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RaisedButton(
            child: Text('Salvar'),
            onPressed: () {
              screenshotController
                  .capture(pixelRatio: 1.5)
                  .then((File image) async {
                //print("Capture Done");
                setState(() {
                  _imageFile = image;
                });
                final result = await ImageGallerySaver.saveImage(image
                    .readAsBytesSync()); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
                print("File Saved to Gallery");
              }).catchError((onError) {
                print(onError);
              });
              // screenshotController.capture().then((File image) {
              //   //Capture Done
              //   setState(() {
              //     _imageFile = image;
              //   });
              // }).catchError((onError) {
              //   print(onError);
              // });
            },
          )
        ],
        title: Text('Text Over Image Image Example'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  height: 500,
                  width: 500,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                              image: DecorationImage(
                                  image: new NetworkImage(
                                      "https://image.freepik.com/free-photo/3d-grunge-room-interior-with-spotlight-smoky-atmosphere-background_1048-11333.jpg"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      HomePage(),
                      SocialMediaName()
                    ],
                  ),
                ),
              ),
              _imageFile != null
                  ? Container(
                      child: Image.file(_imageFile),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                    )
                  : Container(
                      child: Text('oi'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaName extends StatefulWidget {
  @override
  _SocialMediaNameState createState() => _SocialMediaNameState();
}

class _SocialMediaNameState extends State<SocialMediaName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        bottom: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: [
                Image.network(
                  'https://imagepng.org/wp-content/uploads/2017/08/instagram-icone-icon.png',
                  width: 20,
                  height: 15,
                ),
                Text(
                  '@instagram',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Offset offset = Offset.zero;

  final fonts = [
    'SFProDisplayBold',
    'QuickSand',
  ];

  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Oswald',
  );

  String _text = 'Sample Text';

  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.black.withOpacity(0.6),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
                print(offset.dx);
              });
            },
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _tapHandler(_text, _textStyle, _textAlign),
                    child: Text(
                      _text,
                      style: _textStyle,
                      textAlign: _textAlign,
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class Timestamp extends StatelessWidget {
  Timestamp(this.timestamp);

  final DateTime timestamp;

  /// This size could be calculated similarly to the way the text size in
  /// [Bubble] is calculated instead of using magic values.
  static final Size size = Size(60.0, 25.0);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          border: Border.all(color: Colors.yellow),
        ),
        child:
            Text('${timestamp.hour}:${timestamp.minute}:${timestamp.second}'),
      );
}

class Bubble extends StatefulWidget {
  Bubble({@required this.text});

  final TextSpan text;

  @override
  _BubbleState createState() => new _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // The text to render
      final textWidget = Text.rich(widget.text);

      // Calculate the left, top, bottom position of the end of the last text
      // line.
      final lastBox = _calcLastLineEnd(context, constraints);

      // Calculate whether the timestamp fits into the last line or if it has
      // to be positioned after the last line.
      final fitsLastLine =
          constraints.maxWidth - lastBox.right > Timestamp.size.width + 10.0;

      return Stack(
        children: [
          // Ensure the stack is big enough to render the text and the
          // timestamp.
          SizedBox.fromSize(
              size: Size(
                constraints.maxWidth,
                (fitsLastLine ? lastBox.top : lastBox.bottom) +
                    10.0 +
                    Timestamp.size.height,
              ),
              child: Container()),
          // Render the text.
          textWidget,
          // Render the timestamp.
          Positioned(
            left: constraints.maxWidth - (Timestamp.size.width + 10.0),
            top: (fitsLastLine ? lastBox.top : lastBox.bottom) + 5.0,
            child: Timestamp(DateTime.now()),
          ),
        ],
      );
    });
  }

  // Calculate the left, top, bottom position of the end of the last text
  // line.
  TextBox _calcLastLineEnd(BuildContext context, BoxConstraints constraints) {
    final richTextWidget = Text.rich(widget.text).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);
    final lastBox = renderObject
        .getBoxesForSelection(TextSelection(
            baseOffset: 0, extentOffset: widget.text.toPlainText().length))
        .last;
    return lastBox;
  }
}
