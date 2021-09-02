import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:reptile_monitor/screen/ConfigureEnclosure.dart';
import 'package:reptile_monitor/screen/Dashboard.dart';
import 'package:reptile_monitor/screen/Insights.dart';
import 'package:video_player/video_player.dart';

import 'models/EnclosureInfo.dart';
import 'models/EnclosureStatus.dart';
import 'models/SensorValue.dart';
import 'models/SensorLimit.dart';

import 'amplifyconfiguration.dart';

import 'components/SensorGauage.dart';

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

Widget _getDefaultSensorLayout() {
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Card(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          SensorGauge(
              sensorValue: SensorValue(value: 65.0, type: "temp", sensor_id: 0),
              sensorLimit:
                  SensorLimit(min: 75, max: 95, type: "temp", sensor_id: 0)),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Temperature (F)",
              style: TextStyle(fontSize: 24.0, color: Colors.green),
            ),
          )
        ]),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
    Card(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          SensorGauge(
              sensorValue: SensorValue(value: 65.0, type: "temp", sensor_id: 0),
              sensorLimit:
                  SensorLimit(min: 75, max: 95, type: "temp", sensor_id: 0)),
          Container(
              padding: EdgeInsets.all(20),
              child: Text("Humidity",
                  style: TextStyle(fontSize: 24.0, color: Colors.green)))
        ]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)))
  ]);
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
  bool isEnclosureStatusLoaded = false;
  late VideoPlayerController _controller;
  EnclosureInfo _enclosureInfo =
      EnclosureInfo(id: "-1", sensorLimits: <SensorLimit>[]);
  late Future<EnclosureStatus> _enclosureStatus;
  late Future<void> _initializeVideoPlayer;
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    Dashboard(),
    Insights(),
    ConfigureEnclosure()
  ];

  @override
  void initState() {
    super.initState();
    _configureAmplify();
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
      body: _screens[
          _selectedIndex] // Center is a layout widget. It takes a single child and positions it
      ,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.multiline_chart),
              label: "Insights",
              backgroundColor: Colors.greenAccent),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configure',
            backgroundColor: Colors.greenAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (int tap) {
          setState(() {
            _selectedIndex = tap;
          });
        },
      ),
    );
  }
}
