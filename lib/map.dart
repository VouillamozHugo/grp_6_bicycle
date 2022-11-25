import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

//LINK TO API MAP => `https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg`
// carte the base Flutter => https://tile.openstreetmap.org/{z}/{x}/{y}.png
// TERRAIN : https://wmts0.geo.admin.ch/1.0.0/ch.swisstopo.terrain.3d/default/2010,2010-01/3857/100/{x}/{y}.png
void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _allMarkers = <LatLng>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My fucking map")),
        body: Center(
          child: Container(
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
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                          points: _allMarkers,
                          strokeWidth: 15,
                          color: Colors.blue)
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: LatLng(46.283099, 7.539069),
                          builder: (context) => const Icon(
                                Icons.location_on,
                                size: 35,
                                color: Colors.green,
                              )),
                      Marker(
                          point: LatLng(46.283099, 7.449069),
                          builder: (context) => const Icon(
                                Icons.location_on,
                                size: 35,
                                color: Colors.red,
                              ))
                    ],
                  )
                ],
              )),
              FloatingActionButton(onPressed: () {
                _allMarkers.removeLast();
              })
            ]),
          ),
        ));
  }

  void addMarker(LatLng newMarker) {
    _allMarkers.add(newMarker);
  }

  void emptyMarkers() {
    _allMarkers = <LatLng>[];
  }
}
