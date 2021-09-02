import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reptile_monitor/api/GetEnclosureInfo.dart';
import 'package:reptile_monitor/api/PutEnclosureInfo.dart';
import 'package:reptile_monitor/components/SensorLimitEdit.dart';
import 'package:reptile_monitor/models/EnclosureInfo.dart';
import 'package:reptile_monitor/models/SensorLimit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ConfigureEnclosure extends StatefulWidget {
  const ConfigureEnclosure({
    Key? key,
  }) : super(key: key);

  @override
  _ConfigureEnclosureState createState() => _ConfigureEnclosureState();
}

class _ConfigureEnclosureState extends State<ConfigureEnclosure> {
  EnclosureInfo _enclosureInfo =
      EnclosureInfo(id: "-1", sensorLimits: <SensorLimit>[]);

  List<RangeValues> ranges = <RangeValues>[];

  void handleConfigurationChange(SensorLimit limit) {
    for (var sensorLimit in _enclosureInfo.sensorLimits) {
      if (sensorLimit.sensor_id == limit.sensor_id) {
        _enclosureInfo.sensorLimits[
            _enclosureInfo.sensorLimits.indexOf(sensorLimit)] = limit;
      }
    }

    putEnclosureInfo(_enclosureInfo);
  }

  @override
  void initState() {
    super.initState();
    // Allow for Amplify configuration to finish.
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (Amplify.isConfigured) {
        getEnclosureInfo().then((value) => setState(() {
              _enclosureInfo = value;
              ranges.clear();
              for (var sensor in _enclosureInfo.sensorLimits) {
                ranges.add(RangeValues(sensor.min, sensor.max));
              }
            }));
        t.cancel();
      } else {
        print("Not yet configured!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var sensor in _enclosureInfo.sensorLimits)
          Card(
              margin: EdgeInsets.all(10),
              child: SensorLimitEdit(
                  sensorLimit: sensor,
                  onModify: (SensorLimit limit) =>
                      handleConfigurationChange(limit))),
      ],
    ));
  }
}
