import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/Map/BugReportMap.dart';
import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';

import 'DTO/RouteDTO.dart';

class ReportBug extends StatefulWidget {
  final RouteDTO route;

  const ReportBug(this.route, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  final _allMarkers = <Marker>[];
  final _allPolylines = <Polyline>[];
  final TextEditingController startPointText = TextEditingController();
  final TextEditingController endPointText = TextEditingController();
  bool hasbug = false;
  String? selectedRouteId;
  @override
  Widget build(BuildContext context) {
    getRoute();
    return Scaffold(
        appBar: const MyAppBar(
          title: 'Report a problem',
        ),
        body: Column(children: [
          BugReportMap(
              selectedRouteId,
              LatLng(widget.route.coordinates['startLatitude']!,
                  widget.route.coordinates['startLongitude']!),
              LatLng(widget.route.coordinates['endLatitude']!,
                  widget.route.coordinates['endLongitude']!),
              600,
              800),
        ]));
  }

  getRoute() async {
    if (selectedRouteId != null) return;
    String routeIdTemp =
        await RouteDB().getRouteIdByName(widget.route.routeName);
    setState(() {
      selectedRouteId = routeIdTemp;
    });
  }
}
