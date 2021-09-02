import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reptile_monitor/api/GetEnclosureInfo.dart';
import 'package:reptile_monitor/api/GetEnclosureStatus.dart';
import 'package:reptile_monitor/api/GetStream.dart';
import 'package:reptile_monitor/components/SensorGauage.dart';
import 'package:reptile_monitor/models/EnclosureInfo.dart';
import 'package:reptile_monitor/models/EnclosureStatus.dart';
import 'package:reptile_monitor/models/SensorLimit.dart';
import 'package:reptile_monitor/models/SensorValue.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
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

class _DashboardState extends State<Dashboard> {
  late Future<String> streamUrl;
  bool isStreamLoaded = false;
  bool isEnclosureStatusLoaded = false;
  late VideoPlayerController _controller;
  EnclosureInfo _enclosureInfo =
      EnclosureInfo(id: "-1", sensorLimits: <SensorLimit>[]);
  late Future<EnclosureStatus> _enclosureStatus;
  late Future<void> _initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    // Allow for Amplify configuration to finish.
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (Amplify.isConfigured) {
        getEnclosureInfo().then((value) => _enclosureInfo = value);
        _enclosureStatus = getEnclosureStatus();

        getVideoStream().then((value) {
          print("Video Stream api callback $value");
          setState(() {
            _controller = VideoPlayerController.network(value);
            _initializeVideoPlayer = _controller.initialize();
            _controller.play();
            isStreamLoaded = true;
          });
        });

        t.cancel();
      } else {
        print("Not yet configured!");
      }
    });

    // Will periodically retrieve the current status of the enclosure.
    new Timer.periodic(Duration(seconds: 30), (Timer t) {
      setState(() {
        _enclosureStatus = getEnclosureStatus();
        isEnclosureStatusLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Center(
          child: isStreamLoaded
              ? FutureBuilder(
                  future: _initializeVideoPlayer,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        onTap: () {
                          _controller.play();
                        },
                      );
                    } else {
                      return Container(
                          height: 200.0,
                          width: 400.0,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: Center(child: CircularProgressIndicator()));
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
          child: isEnclosureStatusLoaded
              ? FutureBuilder(
                  future: _enclosureStatus,
                  builder: (context, AsyncSnapshot<EnclosureStatus> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("Connection done!");
                      if (snapshot.data != null) {
                        var status = snapshot.data;
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var sensor in status!.sensors)
                                  Card(
                                      margin: EdgeInsets.all(10),
                                      child: Column(children: [
                                        SensorGauge(
                                            sensorValue: sensor,
                                            sensorLimit: _enclosureInfo
                                                .sensorLimits
                                                .where((element) =>
                                                    element.sensor_id ==
                                                    sensor.sensor_id)
                                                .first),
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "${sensor.type.toUpperCase()}",
                                            style: TextStyle(
                                                fontSize: 24.0,
                                                color: Colors.green),
                                          ),
                                        )
                                      ]),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                              ]),
                          Text(
                              "Last updated: ${DateTime.fromMillisecondsSinceEpoch(int.parse(status.CreatedAt.substring(0, status.CreatedAt.indexOf('.'))) * 1000)}",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14.0))
                        ]);
                      }
                    }
                    return _getDefaultSensorLayout();
                  })
              : _getDefaultSensorLayout()),
    ]));
  }
}
