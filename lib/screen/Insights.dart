import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reptile_monitor/api/GetEnclosureData.dart';
import 'package:reptile_monitor/api/GetEnclosureInfo.dart';
import 'package:reptile_monitor/api/GetEnclosureStatus.dart';
import 'package:reptile_monitor/api/GetStream.dart';
import 'package:reptile_monitor/components/SensorGauage.dart';
import 'package:reptile_monitor/models/EnclosureInfo.dart';
import 'package:reptile_monitor/models/EnclosureStatus.dart';
import 'package:reptile_monitor/models/SensorLimit.dart';
import 'package:reptile_monitor/models/SensorValue.dart';
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Insights extends StatefulWidget {
  const Insights({Key? key}) : super(key: key);

  @override
  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  bool isEnclosureStatusLoaded = false;
  EnclosureInfo _enclosureInfo =
      EnclosureInfo(id: "-1", sensorLimits: <SensorLimit>[]);
  late Future<List<EnclosureStatus>> _enclosureStatuses;

  @override
  void initState() {
    super.initState();
    // Allow for Amplify configuration to finish.
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (Amplify.isConfigured) {
        _enclosureStatuses = getEnclosureData();
        getEnclosureInfo().then((value) => _enclosureInfo = value);

        t.cancel();
      } else {
        print("Not yet configured!");
      }
    });

    // Will periodically retrieve the current status of the enclosure.
    new Timer.periodic(Duration(seconds: 30), (Timer t) {
      setState(() {
        var halfMinuteAgo = DateTime.now().millisecondsSinceEpoch - (30 * 1000);
        _enclosureStatuses = getEnclosureData(halfMinuteAgo.toString());
        isEnclosureStatusLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Wut"),
    );
  }
}
