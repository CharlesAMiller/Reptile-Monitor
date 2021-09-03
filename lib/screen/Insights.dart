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
import 'package:reptile_monitor/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Insights extends StatefulWidget {
  const Insights({Key? key}) : super(key: key);

  @override
  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  bool isEnclosureStatusesLoaded = false;
  EnclosureInfo _enclosureInfo =
      EnclosureInfo(id: "-1", sensorLimits: <SensorLimit>[]);
  late Future<List<EnclosureStatus>> _enclosureStatuses;

  @override
  void initState() {
    super.initState();
    // Allow for Amplify configuration to finish.
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (Amplify.isConfigured) {
        _enclosureStatuses = getEnclosureData(DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch.toString());
        _enclosureStatuses.then((value) => setState((){isEnclosureStatusesLoaded = true;}));
        getEnclosureInfo().then((value) => _enclosureInfo = value);

        t.cancel();
      } else {
        print("Not yet configured!");
      }
    });

    // Will periodically retrieve the current status of the enclosure.
    new Timer.periodic(Duration(seconds: 30), (Timer t) {
      setState(() {

        _enclosureStatuses = getEnclosureData(DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch.toString());
        isEnclosureStatusesLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:            
        isEnclosureStatusesLoaded ?
        FutureBuilder(
          future: _enclosureStatuses,
          builder: (BuildContext context, AsyncSnapshot<List<EnclosureStatus>> snapshot) 
          {  
            if (snapshot.connectionState == ConnectionState.done)
            {
              var statuses = snapshot.data; 
              if (statuses == null) return CircularProgressIndicator(); 

              // TODO: Refactor to move these into modular components.
              return Column(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                SfCartesianChart(
                primaryXAxis: CategoryAxis(labelRotation: 90),
                // Chart title
                title: ChartTitle(text: 'Temperature'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<EnclosureStatus, String>>[
                  LineSeries<EnclosureStatus, String>(
                      dataSource: statuses,
                      xValueMapper: (EnclosureStatus status, _) => formatTimeHourMinute(timeFromTimeString(status.CreatedAt)),
                      yValueMapper: (EnclosureStatus status, _) => status.sensors[0].value,
                      name: 'Temperature',
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true)),
                ]), 
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(labelRotation: 90),
                  title: ChartTitle(text: 'Humidity'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<EnclosureStatus, String>>[
                    LineSeries<EnclosureStatus, String>(
                        dataSource: statuses,
                        xValueMapper: (EnclosureStatus status, _) => formatTimeHourMinute(timeFromTimeString(status.CreatedAt)),
                        yValueMapper: (EnclosureStatus status, _) => status.sensors[1].value,
                        name: 'Humidity',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true )),
                  ]), 
              ]);
            }
            else 
            {
              return CircularProgressIndicator();
            }
          })
          :
          Text("The data is still loading")
    );
  }
}
