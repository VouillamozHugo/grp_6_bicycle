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
  var distance;
  var duration;

  final inputTextController = TextEditingController();
  final brown = const Color.fromARGB(255, 80, 62, 33);
  final orange = const Color.fromARGB(255, 212, 134, 34);
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
        height: queryData.size.height * 0.7,
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
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.7,
        child: TextField(
          controller: inputTextController,
          obscureText: false,
          style: TextStyle(
            color: brown,
          ),
          cursorColor: orange,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: orange,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: brown,
                ),
              ),
              labelText: 'Route name',
              labelStyle: TextStyle(color: brown, fontWeight: FontWeight.w500)),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: queryData.size.width * 0.1,
            height: queryData.size.height * 0.1,
            child: IconButton(
              onPressed: changeLayer,
              icon: const Icon(
                Icons.layers,
                size: 50,
                color: Color.fromARGB(255, 212, 134, 34),
              ),
            ),
          ),
          SizedBox(
            width: queryData.size.width * 0.1,
            height: queryData.size.height * 0.1,
            child: IconButton(
                //Icons.keyboard_backspace_rounded
                icon: const Icon(
                  Icons.save,
                  size: 50,
                  color: Color.fromARGB(255, 212, 134, 34),
                ),
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
          ),
        ],
      ),
    ]);
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
      distance = data['features'][0]['properties']['segments'][0]['distance'];
      duration = data['features'][0]['properties']['segments'][0]['duration'];
      print(data.toString());
      duration = duration / 60;
      distance = distance / 1000;
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
      strokeWidth: 8,
      points: _allRoutePoints,
    );
    _allPolylines.add(polyline);

    setState(() {});
  }

  saveRouteInDatabase(nameOfRoute, context) async {
    Map<String, double> coordinates = Map();
    coordinates['startLatitude'] = _allPoints.elementAt(0).latitude;
    coordinates['endLatitude'] = _allPoints.elementAt(1).latitude;
    coordinates['startLongitude'] = _allPoints.elementAt(0).longitude;
    coordinates['endLongitude'] = _allPoints.elementAt(1).longitude;
    RouteDTO route = RouteDTO(
      creatorId: "NotAnIdYet",
      routeName: nameOfRoute,
      startPoint: "Bramois",
      endPoint: "Liddes",
      coordinates: coordinates,
      distanceKm: distance,
      durationMinutes: duration,
      heightDiffUpMeters: 800,
      heightDiffDownMeters: 200,
      numberOfLikes: 0,
    );
    bool success = await routeDB.addRoute(route);
    debugPrint("Start point " + success.toString());
    //clear previous navigation history
    //and load all routes page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllRoutes()),
    );
  }
}
