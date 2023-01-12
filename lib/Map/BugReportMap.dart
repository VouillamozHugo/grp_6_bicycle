import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/NotificationDTO.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

import '../DB/NotificationDB.dart';

class BugReportMap extends StatefulWidget {
  final LatLng startpoint;
  final LatLng endPoint;
  final double mapHeight;
  final double mapWidth;
  bool firstTime = true;
  var route;

  BugReportMap(this.route, this.startpoint, this.endPoint, this.mapHeight,
      this.mapWidth);

  @override
  State<BugReportMap> createState() => _BugReportMap();
}

class _BugReportMap extends State<BugReportMap> {
  final _allPoints = <LatLng>[];
  final _allRoutePoints = <LatLng>[];
  final _allMarkers = <Marker>[];
  final _allClickableMarkers = <Marker>[];
  final _allPolylines = <Polyline>[]; //
  final RouteDB routeDB = RouteDB();
  var _allElevation = <double?>[];
  var data;
  var startElevation;
  var endElevation;
  var distance;
  var duration;
  final TextEditingController startPointText = TextEditingController();
  final TextEditingController endPointText = TextEditingController();
  final TextEditingController textProblem = TextEditingController();
  final NotificationDB notifDB = NotificationDB();
  bool hasBug = false;
  String? selectedRouteId;

  @override
  Widget build(BuildContext context) {
    getRoute();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var count = _allClickableMarkers.length;
    if (widget.firstTime) {
      getJsonData();
      widget.firstTime = false;
    }
    return SizedBox(
      width: widget.mapWidth,
      height: widget.mapHeight,
      child: Column(children: [
        Flexible(
            child: FlutterMap(
          options: MapOptions(
            center:
                LatLng(widget.startpoint.latitude, widget.startpoint.longitude),
            zoom: 15,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
            ),
          ],
          children: [
            TileLayer(
              urlTemplate:
                  'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg',
            ),
            PolylineLayer(
              polylines: _allPolylines,
            ),
            MarkerLayer(markers: _allClickableMarkers)
          ],
        )),
        Text("Start of the problem ( between 0 and $count )"),
        TextField(
          controller: startPointText,
        ),
        Text("End of the problem ( between 0 and $count )"),
        TextField(
          controller: endPointText,
        ),
        const Text("What is the problem ? "),
        TextField(
          controller: textProblem,
        ),
        SizedBox(
          width: queryData.size.width * 0.1,
          height: queryData.size.height * 0.1,
          child: IconButton(
            onPressed: setPolylines,
            icon: const Icon(
              Icons.display_settings,
              size: 50,
              color: Color.fromARGB(255, 212, 134, 34),
            ),
          ),
        ),
        SizedBox(
          width: queryData.size.width * 0.1,
          height: queryData.size.height * 0.1,
          child: IconButton(
            onPressed: saveNotificationInDB,
            icon: const Icon(
              Icons.save,
              size: 50,
              color: Color.fromARGB(255, 212, 134, 34),
            ),
          ),
        ),
      ]),
    );
  }

  getRoute() async {
    if (selectedRouteId != null) return;
    String routeIdTemp =
        await RouteDB().getRouteIdByName(widget.route.routeName);
    setState(() {
      selectedRouteId = routeIdTemp;
    });
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    print("Get data");
    try {
      // getData() returns a json Decoded data
      // data = await network.getData();
      OpenRouteService openRouteService = OpenRouteService(
          apiKey: '5b3ce3597851110001cf6248f83ccaf685cb453bb7c34e18c7a9e31f');
      List<ORSCoordinate> routeCoordinates =
          await openRouteService.directionsRouteCoordsGet(
              startCoordinate: ORSCoordinate(
                  latitude: widget.startpoint.latitude,
                  longitude: widget.startpoint.longitude),
              endCoordinate: ORSCoordinate(
                  latitude: widget.endPoint.latitude,
                  longitude: widget.endPoint.longitude));

      for (int i = 0; i < routeCoordinates.length; i++) {
        _allRoutePoints.add(LatLng(
            routeCoordinates[i].latitude, routeCoordinates[i].longitude));
        if (i % 12 == 0) {
          var marker = Marker(
              point: LatLng(
                  routeCoordinates[i].latitude, routeCoordinates[i].longitude),
              builder: (context) => const Icon(
                    Icons.circle,
                    size: 15,
                    color: Color.fromARGB(255, 51, 102, 197),
                  ));

          _allClickableMarkers.add(marker);
        }
      }
      var markerStart = Marker(
          point: widget.startpoint,
          builder: (context) => const Icon(
                Icons.add_location,
                size: 50,
                color: Color.fromARGB(255, 180, 14, 2),
              ));
      _allClickableMarkers.add(markerStart);
      var markerEnd = Marker(
          point: widget.endPoint,
          builder: (context) => const Icon(
                Icons.add_location,
                size: 50,
                color: Color.fromARGB(255, 180, 14, 2),
              ));
      _allClickableMarkers.add(markerEnd);
      setPolylines();
    } catch (e) {
      print(e);
    }
  }

  setPolylines() {
    final _segment1 = <LatLng>[];
    final _segment2 = <LatLng>[];
    final _segment3 = <LatLng>[];

    if (startPointText.text.isNotEmpty && endPointText.text.isNotEmpty) {
      if (int.parse(startPointText.text) > 0 &&
          int.parse(startPointText.text) < _allClickableMarkers.length &&
          int.parse(endPointText.text) > 0 &&
          int.parse(endPointText.text) < _allClickableMarkers.length) {
        var IndexfinSegment1 = int.parse(startPointText.text);
        var IndexfinSegment2 = int.parse(endPointText.text);

        LatLng finSegment1 = _allClickableMarkers[IndexfinSegment1].point;
        LatLng finSegment2 = _allClickableMarkers[IndexfinSegment2].point;

        var index1 = _allRoutePoints.indexOf(finSegment1);

        for (var i = 0; i < index1; i++) {
          _segment1.add(_allRoutePoints[i]);
        }
        var index2 = _allRoutePoints.indexOf(finSegment2);

        for (var i = index1; i < index2; i++) {
          _segment2.add(_allRoutePoints[i]);
        }
        for (var i = index2; i < _allRoutePoints.length; i++) {
          _segment3.add(_allRoutePoints[i]);
        }

        Polyline polyline = Polyline(
          //  polylineId: PolylineId("polyline"),
          color: Colors.green,
          strokeWidth: 10,
          points: _segment1,
        );
        Polyline polyline2 = Polyline(
          //  polylineId: PolylineId("polyline"),
          color: Colors.orange,
          strokeWidth: 10,
          points: _segment2,
        );
        Polyline polyline3 = Polyline(
          //  polylineId: PolylineId("polyline"),
          color: Colors.green,
          strokeWidth: 10,
          points: _segment3,
        );
        for (var i = 0; i < _allPolylines.length; i++) {
          _allPolylines.removeLast();
        }
        _allPolylines.add(polyline);
        _allPolylines.add(polyline2);
        _allPolylines.add(polyline3);
      }
    } else {
      Polyline polyline = Polyline(
        color: Colors.green,
        strokeWidth: 10,
        points: _allRoutePoints,
      );

      _allPolylines.add(polyline);
    }

    setState(() {});
  }

  saveNotificationInDB() async {
    var IndexfinSegment1 = int.parse(startPointText.text);
    var IndexfinSegment2 = int.parse(endPointText.text);

    LatLng finSegment1 = _allClickableMarkers[IndexfinSegment1].point;
    LatLng finSegment2 = _allClickableMarkers[IndexfinSegment2].point;

    Map<String, double> problemCoords = Map();
    problemCoords['endLatCoord'] = finSegment2.latitude;
    problemCoords['endLongCoord'] = finSegment2.longitude;
    problemCoords['startLatCoord'] = finSegment1.latitude;
    problemCoords['startLongCoord'] = finSegment1.longitude;

    NotificationDTO notification = NotificationDTO(
        problemDescription: textProblem.text,
        isValidatedByAdmin: false,
        affectedRouteId: selectedRouteId!,
        problemCoords: problemCoords);

    bool success = await notifDB.addNotif(notification);
    if (success) {
      Navigator.pushNamed(context, RouteNames.allRoutes);
    }
  }
}
