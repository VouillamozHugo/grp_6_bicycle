import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';

import 'networkin.dart';

import 'DB/UserDB.dart';
import 'DTO/UserDTO.dart';
import 'firebase_options.dart';

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
  final RouteDB routeDB = RouteDB();

  var layer =
      'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
  var sateliteIsOn = false;

  var data;

  final inputTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextField(controller: inputTextController),
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
            TileLayer(urlTemplate: layer),
            PolylineLayer(
              polylines: _allPolylines,
            ),
            MarkerLayer(markers: _allMarkers)
          ],
        )),
        FloatingActionButton(
          heroTag: "layersButton",
          onPressed: changeLayer,
          child: const Icon(Icons.layers),
          backgroundColor: Colors.transparent,
        ),
        FloatingActionButton(
            heroTag: "saveButton",
            //Icons.keyboard_backspace_rounded,
            backgroundColor: Colors.transparent,
            child: const Icon(Icons.save),
            onPressed: () {
              if (_allPoints.length == 2) {
                if (inputTextController.text.isNotEmpty) {
                  saveRouteInDatabase(inputTextController.text, context);
                }
              }
              _allMarkers.clear();
              _allPoints.clear();
              _allPolylines.clear();
              _allRoutePoints.clear();

              setState(() {});
            }),
      ]),
    );
  }

  void changeLayer() {
    if (sateliteIsOn) {
      layer =
          'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
    } else {
      layer =
          'https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg';
    }
    sateliteIsOn = !sateliteIsOn;
    setState(() {});
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
      // We can reach to our desired JSON data manually as following

      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

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
      strokeWidth: 8,
      points: _allRoutePoints,
    );
    _allPolylines.add(polyline);

    setState(() {});
  }

  findRouteInDB() async {
    RouteDTO? route = await routeDB.getRouteByName("benjamin");
    if (route != null) {
      LatLng startpoint = LatLng(route.coordinates['startLatitude']!,
          route.coordinates['startLongitude']!);
      LatLng endPoint = LatLng(route.coordinates['endLatitude']!,
          route.coordinates['endLongitude']!);
      _allPoints.add(startpoint);
      _allPoints.add(endPoint);
      getJsonData();
    }
  }

  saveRouteInDatabase(nameOfRoute, context) async {
    Map<String, double> coordinates = Map();
    coordinates['startLatitude'] = _allPoints.elementAt(0).latitude;
    coordinates['endLatitude'] = _allPoints.elementAt(1).latitude;
    coordinates['startLongitude'] = _allPoints.elementAt(0).longitude;
    coordinates['endLongitude'] = _allPoints.elementAt(1).longitude;
    RouteDTO route = RouteDTO(
        routeName: nameOfRoute,
        startPoint: "Bramois",
        endPoint: "Liddes",
        coordinates: coordinates,
        distanceKm: 59,
        durationMinutes: 240,
        heightDiffUpMeters: 800,
        heightDiffDownMeters: 200);
    bool success = await routeDB.addRoute(route);
    debugPrint("Start point " + success.toString());
    //clear previous navigation history
    //and load all routes page
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AllRoutes()),
        ModalRoute.withName("/Home"));
  }
}
