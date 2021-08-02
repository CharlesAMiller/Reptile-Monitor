import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:video_player/video_player.dart';

import 'models/EnclosureInfo.dart';
import 'models/EnclosureStatus.dart';

import 'amplifyconfiguration.dart';

import 'components/HeatGauge.dart';

import 'api/GetEnclosureInfo.dart';
import 'api/GetEnclosureStatus.dart';
import 'api/GetStream.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Reptile Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String> streamUrl;
  bool isStreamLoaded = false;
  late VideoPlayerController _controller;
  late Future<EnclosureInfo> _enclosureInfo;
  late Future<EnclosureStatus> _enclosureStatus;
  late Future<void> _initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    // Allow for Amplify configuration to finish.
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (Amplify.isConfigured) {
        getVideoStream().then((value) {
          print("Video Stream api callback $value");
          setState(() {
            _controller = VideoPlayerController.network(value);
            _initializeVideoPlayer = _controller.initialize();
            _controller.play();
            isStreamLoaded = true;
          });
        });

        _enclosureInfo = getEnclosureInfo();
        t.cancel();
      } else {
        print("Not yet configured!");
      }
    });

    // Will periodically retrieve the current status of the enclosure.
    new Timer.periodic(Duration(minutes: 1), (Timer t) {
      _enclosureStatus = getEnclosureStatus();
    });
  }

  void _configureAmplify() async {
    // Add the following line to add API plugin to your app.
    // Auth plugin needed for IAM authorization mode, which is default for REST API.
    Amplify.addPlugins([AmplifyAPI(), AmplifyAuthCognito()]);

    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: // Center is a layout widget. It takes a single child and positions it
          Container(
              child: Column(children: [
        Center(
            child: isStreamLoaded
                ? FutureBuilder(
                    future: _initializeVideoPlayer,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
                : Container(
                    height: 200.0,
                    width: 400.0,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Center(
                      child: Text("Video stream is currently unavailable."),
                    ))),
        FittedBox(
          fit: BoxFit.fitWidth,
          // in the middle of the parent.
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Card(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  HeatGauge(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Temperature (F)",
                      style: TextStyle(fontSize: 24.0, color: Colors.green),
                    ),
                  )
                ]),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
            Card(
                margin: EdgeInsets.all(10),
                child: Column(children: [
                  HeatGauge(),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Text("Humidity",
                          style:
                              TextStyle(fontSize: 24.0, color: Colors.green)))
                ]),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)))
          ]),
        ),
      ])),
    );
  }
}
