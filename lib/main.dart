import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
        appBar: AppBar(title: const Text("My fucking map")),
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
  final _allMarkers = <Marker>[];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Flexible(
            child: FlutterMap(
          options: MapOptions(
            onLongPress: (tapPosition, point) => moveEndPoint(point),
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
              polylines: [
                Polyline(points: _allPoints, strokeWidth: 5, color: Colors.red)
              ],
            ),
            MarkerLayer(markers: _allMarkers)
          ],
        )),
        FloatingActionButton(
            //Icons.keyboard_backspace_rounded,
            backgroundColor: const Color.fromARGB(255, 235, 146, 35),
            onPressed: () {
              removeLastMarker();
            }),
      ]),
    );
  }

  void addMarker(LatLng newPoint) {
    // create the new marker (the beginning or the end of the path)

    if (_allMarkers.length > 1) {
      _allMarkers.removeLast();
      var smallmarker = Marker(
          point: _allPoints.elementAt(_allPoints.length - 1),
          builder: (context) => const Icon(
                Icons.circle,
                size: 15,
                color: Color.fromARGB(255, 180, 14, 2),
              ));
      _allMarkers.add(smallmarker);
    }
    _allMarkers.add(createEnd_start_Marker(newPoint));

    _allPoints.add(newPoint);
  }

  void removeLastMarker() {
    if (_allPoints.isNotEmpty) {
      _allPoints.removeLast();
      _allMarkers.removeLast();
      _allMarkers.removeLast();

      if (_allPoints.length > 1) {
        _allMarkers.add(createEnd_start_Marker(
            _allPoints.elementAt(_allPoints.length - 1)));
      }
    }
    setState(() {});
  }

  void moveEndPoint(LatLng newPoint) {
    // create the new marker (the beginning or the end of the path)

    if (_allPoints.isNotEmpty) {
      _allMarkers.removeLast();
      _allPoints.removeLast();

      _allPoints.add(newPoint);
      _allMarkers.add(createEnd_start_Marker(newPoint));
    }
  }

// put the marker creation in a class to avoid code repetition
  Marker createEnd_start_Marker(LatLng position) {
    var marker = Marker(
        point: position,
        builder: (context) => const Icon(
              Icons.circle,
              size: 25,
              color: Color.fromARGB(255, 180, 14, 2),
            ));
    return marker;
  }
}
