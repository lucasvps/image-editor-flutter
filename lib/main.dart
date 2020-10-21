import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
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

  File _imageFile;

  ScreenshotController screenshotController = ScreenshotController();

  Offset offset = Offset.zero;

  Offset offset2 = Offset.zero;

  final fonts = [
    'SFProDisplayBold',
    'QuickSand',
  ];

  TextStyle _textStyle = TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: '',
  );

  void changeFontFamilyHandler(fontFamily) {
    setState(() {
      _textStyle = TextStyle(
        color: _textStyle.color,
        fontFamily: fontFamily,
        fontSize: _textStyle.fontSize,
      );
    });
  }

  String _text = 'Texto Editavel';

  TextAlign _textAlign = TextAlign.center;

  bool hasBorder = true;

  @override
  Widget build(BuildContext context) {
    final fonts = [
      'SFProDisplayBold',
      'QuickSand',
    ];

    String _image =
        "https://i1.wp.com/multarte.com.br/wp-content/uploads/2019/03/facebook-logo-png2.png?resize=696%2C696&ssl=1";

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  offset = Offset.zero;
                });
              }),
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
              }).catchError((onError) {
                print(onError);
              });
            },
          )
        ],
        title: Text('Text Over Image Image Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fonts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(), shape: BoxShape.circle),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => changeFontFamilyHandler(fonts[index]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tt',
                              style: TextStyle(
                                  fontFamily: fonts[index], fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                height: 500,
                width: 500,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasBorder = false;
                        });
                      },
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
                    Container(
                      child: Positioned(
                        left: offset.dx,
                        top: offset.dy,
                        child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                offset = Offset(offset.dx + details.delta.dx,
                                    offset.dy + details.delta.dy);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: hasBorder
                                          ? Colors.white
                                          : Colors.transparent)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hasBorder = true;
                                      });
                                      _tapHandler(
                                        _text,
                                        _textStyle,
                                        _textAlign,
                                      );
                                    },
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
                    ),
                    Container(
                      child: Positioned(
                        left: offset2.dx,
                        top: offset2.dy,
                        child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                offset2 = Offset(offset2.dx + details.delta.dx,
                                    offset2.dy + details.delta.dy);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.transparent)),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Image.network(
                                    _image,
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
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

class LogoOverImage extends StatefulWidget {
  @override
  _LogoOverImageState createState() => _LogoOverImageState();
}

class _LogoOverImageState extends State<LogoOverImage> {
  Offset offset = Offset.zero;

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
              });
            },
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.network(
                    'https://imagepng.org/wp-content/uploads/2017/08/instagram-icone-icon.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
