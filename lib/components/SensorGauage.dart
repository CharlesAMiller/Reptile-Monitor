import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/SensorValue.dart';
import '../models/SensorLimit.dart';

class SensorGauge extends StatefulWidget {
  const SensorGauge({
    this.sensorValue =
        const SensorValue(sensor_id: 0, type: "temperature", value: 100.0),
    this.sensorLimit =
        const SensorLimit(max: 100, min: 0, type: "temperature", sensor_id: 0),
    Key? key,
  }) : super(key: key);

  final SensorValue sensorValue;
  final SensorLimit sensorLimit;

  @override
  _SensorGaugeState createState() => _SensorGaugeState();
}

class _SensorGaugeState extends State<SensorGauge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: widget.sensorLimit.min - 5,
          maximum: widget.sensorLimit.max + 5,
          labelsPosition: ElementsPosition.outside,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: widget.sensorLimit.min - 5,
                endValue: widget.sensorLimit.min,
                labelStyle: GaugeTextStyle(color: Colors.white),
                startWidth: 40,
                endWidth: 40,
                color: Colors.lightBlue),
            GaugeRange(
              startValue: widget.sensorLimit.min,
              endValue: widget.sensorLimit.max,
              startWidth: 40,
              endWidth: 40,
              color: Colors.lightGreen,
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
                startValue: widget.sensorLimit.max,
                endValue: widget.sensorLimit.max + 5,
                startWidth: 40,
                endWidth: 40,
                color: Colors.red,
                labelStyle: GaugeTextStyle(color: Colors.white)),
          ],
          pointers: [NeedlePointer(value: widget.sensorValue.value)],
          annotations: [
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0.5,
                widget: Container(
                    child: Text('${widget.sensorValue.value}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))))
          ],
        ),
      ],
    );
  }
}
/*
@override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 70,
          maximum: 100,
          labelsPosition: ElementsPosition.outside,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 70,
                endValue: 75,
                label: "Freezing!",
                labelStyle: GaugeTextStyle(color: Colors.white),
                startWidth: 40,
                endWidth: 40,
                color: Colors.lightBlue),
            GaugeRange(
              startValue: 75,
              endValue: 80,
              startWidth: 40,
              endWidth: 40,
              color: Colors.blue,
              label: "Cold",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
              startValue: 80,
              endValue: 88,
              startWidth: 40,
              endWidth: 40,
              color: Colors.lightGreen,
              label: "Ideal (Ambient)",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
                startValue: 88,
                endValue: 92,
                startWidth: 40,
                endWidth: 40,
                color: Colors.green,
                label: "Ideal (Hide)",
                labelStyle: GaugeTextStyle(color: Colors.white)),
            GaugeRange(
              startValue: 92,
              endValue: 95,
              startWidth: 40,
              endWidth: 40,
              color: Colors.redAccent,
              label: "Warm",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
              startValue: 95,
              endValue: 100,
              color: Colors.red,
              startWidth: 40,
              endWidth: 40,
              label: "Scorching!",
              labelStyle: GaugeTextStyle(color: Colors.white),
            )
          ],
          pointers: [NeedlePointer(value: temp)],
        ),
      ],
    );
  }
}*/