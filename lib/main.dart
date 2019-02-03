import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';
import 'package:soundpool/soundpool.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(
    NotifierProvider(
      child: MyApp(),
    )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void loadAudio(String asset) async {
    ByteData bytes = await rootBundle.load(asset);
    soundId = await pool.load(bytes);
    print(soundId);
  }

  final toggleSize = 30.0;
  final foregroundColor = Colors.green;
  int soundId = 0;
  Soundpool pool = new Soundpool(streamType: StreamType.notification);

  Container makeContainer(BuildContext context, String buttonText) {
    final String eventId = 'button${buttonText}';
    final Notifier _notifier = NotifierProvider.of(context);
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
      child: Row(
        children: <Widget>[
          ToggleButton(
            buttonText: buttonText,
            borderRadius: 5.0,
            foregroundColor: Colors.green[700],
            deactivatedColor: Colors.green[800],
            backgroundColor: Colors.purple[800],
            size: toggleSize,
            onChange: (status) {
              _notifier.notify(eventId, status ? "on" : "off");
              if(soundId > 0) {
                pool.play(soundId);
              }
            },
          ),
          SizedBox(width: 50),
          _notifier.register<String>(eventId, (state) {
            final bool _activated = state.data == "on";
            return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: _activated ? Colors.green[700] : Colors.purple[800],
                    borderRadius: BorderRadius.circular(3.0)
                ),
                child: Center(
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(_activated ? "1" : "0", style: TextStyle(fontWeight: FontWeight.bold,
                            color: _activated ? Colors.black : Colors.white))
                    )
                )
            );
          })
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    loadAudio('sounds/swipe.m4a');
    return MaterialApp(
      home: Scaffold(
          body: Container(
            decoration: new BoxDecoration(color: Colors.purple[900]),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100.0),
                makeContainer(context, '128'),
                makeContainer(context, '64'),
                makeContainer(context, '32'),
                makeContainer(context, '16'),
                makeContainer(context, '8'),
                makeContainer(context, '4'),
                makeContainer(context, '2'),
                makeContainer(context, '1'),
                Row(
                  children: <Widget>[
                    SizedBox(width: 35.0),
                    RotatedBox(
                        quarterTurns: 1,
                        child: Text('OFF', style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                    SizedBox(width: 165.0),
                    RotatedBox(
                        quarterTurns: 1,
                        child: Text('ON', style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                  ]
                )
              ],
            ),
          )),
    );
  }
}

class BinaryIndicator extends StatefulWidget {
  bool activated;
  BinaryIndicatorState currentState;

  BinaryIndicator({this.activated});

  @override
  State<StatefulWidget> createState() {
    currentState = new BinaryIndicatorState();
    return currentState;
  }
}

class BinaryIndicatorState extends State<BinaryIndicator> {
  bool _activated;

  void activate(bool state) {
    setState(() {
      _activated = state;
    });
  }

  void start() {
    if(widget.activated != null)
      _activated = widget.activated;
    else
      _activated = false;
  }

  @override
  Widget build(BuildContext context) {
    start();

    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: _activated ? Colors.green[600] : Colors.purple[600],
            borderRadius: BorderRadius.circular(3.0)
        ),
        child: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(_activated ? "1" : "0", style: TextStyle(fontWeight: FontWeight.bold,
                color: _activated ? Colors.black : Colors.white))
          )
        )
    );
  }
}

class ToggleButton extends StatefulWidget {
  double size;
  String buttonText;
  Color backgroundColor;
  Color foregroundColor;
  Color deactivatedColor;
  double borderRadius;
  void Function(bool status) onChange;
  bool initialVale;
  List<BoxShadow> boxShadow = [];
  ToggleButton(
      {this.size,
        this.backgroundColor,
        this.foregroundColor,
        this.borderRadius,
        this.initialVale,
        this.deactivatedColor,
        this.boxShadow,
        this.onChange,
        this.buttonText});

  @override
  State<StatefulWidget> createState() {
    return ToggleButtonState();
  }
}

class ToggleButtonState extends State<ToggleButton> {
  bool _active = false;
  double size;
  Color backgroundColor;
  Color foregroundColor;
  Color deactivatedColor;
  double borderRadius;
  bool initialVale;
  double width;
  double height;
  String buttonText;

  void start() {
    if (widget.size != null)
      size = widget.size;
    else
      size = 15.0;

    if (widget.backgroundColor != null)
      backgroundColor = widget.backgroundColor;
    else
      backgroundColor = Colors.green;

    if (widget.foregroundColor != null)
      foregroundColor = widget.foregroundColor;
    else
      foregroundColor = Colors.white;

    if (widget.initialVale != null)
      _active = widget.initialVale;


    if (widget.borderRadius != null)
      borderRadius = widget.borderRadius;
    else
      borderRadius = 40.0;

    if (widget.deactivatedColor != null)
      deactivatedColor = widget.deactivatedColor;
    else
      deactivatedColor = Colors.grey;

    if(widget.buttonText != null)
      buttonText = widget.buttonText;
    else
      buttonText = '1';
  }

  @override
  Widget build(BuildContext context) {
    start();

    width = size * 8.0;
    height = size * 2.0;

    return GestureDetector(
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 15.0,
              child: Container(
                width: width,
                height: height - 30,
                decoration: BoxDecoration(
                    color: _active ? backgroundColor : deactivatedColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: widget.boxShadow),
              ),
            ),
            Positioned(
                top: 0.0,
                left: _active ? width - height : 0.0,
                child: Container(
                  width: height - 2.0,
                  height: height - 2.0,
                  margin: EdgeInsets.all(1.0),
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(buttonText, style: TextStyle(fontWeight: FontWeight.bold))
                    )
                  ),
                  decoration: BoxDecoration(
                      color: foregroundColor,
                      borderRadius: BorderRadius.circular(borderRadius)),
                ))
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _active = !_active;
        });

        if (widget.onChange != null) {
          widget.onChange(_active);
        }
      },
    );
  }
}
