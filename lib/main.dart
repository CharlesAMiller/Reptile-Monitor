import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'amplifyconfiguration.dart';

import 'components/HeatGauge.dart';
import 'models/TemperatureStatus.dart';

Future<TemperatureStatus> fetchStatus() async {
  final response = await http.get(
      Uri.parse(
          "https://ydrgbyjuk9.execute-api.us-west-2.amazonaws.com/beta/3/status"),
      headers: {'Content-type': 'application/json'});
  print("Reached");
  if (response.statusCode == 200) {
    print(response.body);
    return TemperatureStatus.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode);
    throw Exception('Failed to load status');
  }
}

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<TemperatureStatus> futureStatus;

  @override
  void initState() {
    super.initState();
    futureStatus = fetchStatus();
    _configureAmplify();
  }

  void onTestApi() async {
    try {
      RestOptions options = RestOptions(
          path: '/enclosure/3',
          queryParameters: {'TableName': 'EnclosureStatus'});
      RestOperation restOperation = Amplify.API.get(restOptions: options);
      RestResponse response = await restOperation.response;
      print('GET call succeeded');
      print(String.fromCharCodes(response.data));
    } on ApiException catch (e) {
      print('GET call failed: $e');
    }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: // Center is a layout widget. It takes a single child and positions it
          FittedBox(
        fit: BoxFit.fitWidth,
        // in the middle of the parent.
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              margin: EdgeInsets.all(20),
              child: HeatGauge(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100))),
          Card(margin: EdgeInsets.all(20), child: HeatGauge())
        ]),
      ),
    );
  }
}
