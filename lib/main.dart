import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'networkin.dart';

//LINK TO API MAP => `https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg`
// carte the base Flutter => https://tile.openstreetmap.org/{z}/{x}/{y}.png
// https://ch.swisstopo.swisstlm3d-strassen/{z}/{x}/{y}.png
// TERRAIN : https://wmts0.geo.admin.ch/1.0.0/ch.swisstopo.terrain.3d/default/2010,2010-01/3857/100/{x}/{y}.png
void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My map")),
        body: const Center(child: MarkersOnMap()));
  }
}

class MarkersOnMap extends StatefulWidget {
  const MarkersOnMap({super.key});

  @override
  State<MarkersOnMap> createState() => _MarkersOnMapState();
}

class _MarkersOnMapState extends State<MarkersOnMap> {
  final _allPoints = <LatLng>[];
  final _allRoutePoints = <LatLng>[];
  final _allMarkers = <Marker>[];
  final _allPolylines = <Polyline>[]; //
  double startLat = 46.283274;
  double startLng = 7.539856;
  double endLat = 46.292957;
  double endLng = 7.532569;
  var data;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Flexible(
            child: FlutterMap(
          options: MapOptions(
            onTap: (tapPosition, point) => addMarker(point),
            center: LatLng(46.283099, 7.539069),
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
            MarkerLayer(markers: _allMarkers)
          ],
        )),
        FloatingActionButton(
            //Icons.keyboard_backspace_rounded,
            backgroundColor: const Color.fromARGB(255, 235, 146, 35),
            onPressed: () {
              _allMarkers.clear();
              _allPoints.clear();
              _allPolylines.clear();
              _allRoutePoints.clear();
              setState(() {});
            }),
      ]),
    );
  }

  void addMarker(LatLng newPoint) {
    if (_allPoints.length < 2) {
      var marker = Marker(
          point: newPoint,
          builder: (context) => const Icon(
                Icons.add_location,
                size: 50,
                color: Color.fromARGB(255, 180, 14, 2),
              ));
      _allMarkers.add(marker);
      _allPoints.add(newPoint);
      if (_allPoints.length == 2) {
        print("Getting json data");
        getJsonData();
      }
    }
  }

// PART FOR THE ROUTE

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: _allPoints.elementAt(0).latitude,
      startLng: _allPoints.elementAt(0).longitude,
      endLat: _allPoints.elementAt(1).latitude,
      endLng: _allPoints.elementAt(1).longitude,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      print("data return");
      // We can reach to our desired JSON data manually as following

      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      var distance = data['features'][0]['properties']['segments']['distance'];
      print(distance);

      //  print(distance.toString());

      for (int i = 0; i < ls.lineString.length; i++) {
        _allRoutePoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (_allRoutePoints.length == ls.lineString.length) {
        print("Set polylines");
        print(_allRoutePoints.length);
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

    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
