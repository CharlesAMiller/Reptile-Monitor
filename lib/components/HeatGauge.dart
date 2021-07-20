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
  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 60,
          maximum: 110,
          ranges: <GaugeRange>[
            GaugeRange(
                startValue: 60,
                endValue: 75,
                label: "Freezing!",
                labelStyle: GaugeTextStyle(color: Colors.white),
                color: Colors.lightBlue),
            GaugeRange(
              startValue: 75,
              endValue: 80,
              color: Colors.blue,
              label: "Cold",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
              startValue: 80,
              endValue: 88,
              color: Colors.lightGreen,
              label: "Ideal (Ambient)",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
                startValue: 88,
                endValue: 92,
                color: Colors.green,
                label: "Ideal (Hide)",
                labelStyle: GaugeTextStyle(color: Colors.white)),
            GaugeRange(
              startValue: 92,
              endValue: 95,
              color: Colors.redAccent,
              label: "Warm",
              labelStyle: GaugeTextStyle(color: Colors.white),
            ),
            GaugeRange(
              startValue: 95,
              endValue: 110,
              color: Colors.red,
              label: "Scorching!",
              labelStyle: GaugeTextStyle(color: Colors.white),
            )
          ],
        ),
      ],
    );
  }
}
