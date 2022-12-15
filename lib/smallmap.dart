import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:latlong2/latlong.dart';

import 'Map/networkin.dart';

import 'DB/UserDB.dart';
import 'DTO/UserDTO.dart';
import 'firebase_options.dart';

class SmallMap extends StatefulWidget {
  final LatLng startpoint;
  final LatLng endPoint;
  final double mapHeight;
  final double mapWidth;
  const SmallMap(this.startpoint, this.endPoint, this.mapHeight, this.mapWidth);

  @override
  State<SmallMap> createState() => _SmallMapState();
}

class _SmallMapState extends State<SmallMap> {
  final _allRoutePoints = <LatLng>[];
  final _allMarkers = <Marker>[];
  final _allPolylines = <Polyline>[]; //
  final RouteDB routeDB = RouteDB();
  var data;

  @override
  Widget build(BuildContext context) {
    getJsonData();
    return SizedBox(
      width: widget.mapWidth,
      height: widget.mapHeight,
      child: Column(children: [
        Flexible(
            child: FlutterMap(
          options: MapOptions(
            center:
                LatLng(widget.startpoint.latitude, widget.startpoint.longitude),
            zoom: 11,
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
            MarkerLayer(markers: _allMarkers)
          ],
        )),
      ]),
    );
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format
    NetworkHelper network = NetworkHelper(
      startLat: widget.startpoint.latitude,
      startLng: widget.startpoint.longitude,
      endLat: widget.endPoint.latitude,
      endLng: widget.endPoint.longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following

      if (data == null) return;
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      //  print(distance.toString());

      for (int i = 0; i < ls.lineString.length; i++) {
        _allRoutePoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (_allRoutePoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      //  polylineId: PolylineId("polyline"),
      color: Colors.red,
      strokeWidth: 10,
      points: _allRoutePoints,
    );
    _allPolylines.add(polyline);
    var markerStart = Marker(
        point: widget.startpoint,
        builder: (context) => const Icon(
              Icons.add_location,
              size: 50,
              color: Color.fromARGB(255, 180, 14, 2),
            ));
    _allMarkers.add(markerStart);
    var markerEnd = Marker(
        point: widget.endPoint,
        builder: (context) => const Icon(
              Icons.add_location,
              size: 50,
              color: Color.fromARGB(255, 180, 14, 2),
            ));
    _allMarkers.add(markerEnd);

    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
