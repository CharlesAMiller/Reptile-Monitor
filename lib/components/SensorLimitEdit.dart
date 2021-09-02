import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:reptile_monitor/api/GetEnclosureInfo.dart';
import 'package:reptile_monitor/models/EnclosureInfo.dart';
import 'package:reptile_monitor/models/SensorLimit.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SensorLimitEdit extends StatefulWidget {
  final Function(SensorLimit) onModify;
  final SensorLimit sensorLimit;

  const SensorLimitEdit(
      {Key? key,
      this.sensorLimit = const SensorLimit(
          max: 100, min: 0, type: "temperature", sensor_id: 0),
      required this.onModify})
      : super(key: key);

  @override
  _SensorLimitEditState createState() => _SensorLimitEditState();
}

class _SensorLimitEditState extends State<SensorLimitEdit> {
  late RangeValues range;
  late SensorLimit _limit = widget.sensorLimit;

  @override
  void initState() {
    super.initState();
    range = RangeValues(widget.sensorLimit.min, widget.sensorLimit.max);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Align(
            child: Text(
              "${_limit.sensor_id} - ${_limit.type}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.centerLeft),
        RangeSlider(
            divisions: 120,
            min: 0,
            max: 120,
            values: range,
            labels: RangeLabels(
                range.start.round().toString(), range.end.round().toString()),
            onChanged: (RangeValues values) {
              setState(() {
                _limit = SensorLimit(
                    max: values.end,
                    min: values.start,
                    sensor_id: _limit.sensor_id,
                    type: _limit.type);
                range = values;
              });
            }),
        MaterialButton(
            color: Colors.green,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              widget.onModify(_limit);
            }),
      ],
    ));
  }
}
