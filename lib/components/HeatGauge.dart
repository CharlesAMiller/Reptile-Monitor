import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeatGauge extends StatefulWidget {
  const HeatGauge({
    Key? key,
  }) : super(key: key);

  @override
  _HeatGaugeState createState() => _HeatGaugeState();
}

class _HeatGaugeState extends State<HeatGauge> {
  var temp = 60.0;
  @override
  void initState() {
    super.initState();
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        temp += 1;
        if (temp > 100) temp = 60.0;
      });
    });
  }

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
}
