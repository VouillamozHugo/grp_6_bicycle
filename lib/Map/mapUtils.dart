import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/Map/all_routes.dart';
import 'package:grp_6_bicycle/Map/geolocation.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';
import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';
import 'networkin.dart';
import '../DB/UserDB.dart';
import '../DTO/UserDTO.dart';
import '../firebase_options.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:geolocator/geolocator.dart';

class MarkersOnMap extends StatefulWidget {
  const MarkersOnMap({super.key});

  @override
  State<MarkersOnMap> createState() => _MarkersOnMapState();
}

class _MarkersOnMapState extends State<MarkersOnMap> {
  final _allPoints = <LatLng>[];
  var _allRoutePoints = <LatLng>[];
  final _allMarkers = <Marker>[];
  final _allPolylines = <Polyline>[]; //
  final RouteDB routeDB = RouteDB();
  var _allElevation = <double?>[];
  final _features = <Feature>[];
  final _labelX = <String>[];
  final geolocation _geolocation = geolocation();

  LatLng centerScreen = LatLng(46.283099, 7.539069);

  final GeolocatorPlatform _geolocatorPlateform = GeolocatorPlatform.instance;

  var layer =
      'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
  var sateliteIsOn = false;

  var data;
  var distance;
  var duration;
  var startElevation;
  var endElevation;

/*
     LineGraph(
          features: _features,
          size: const Size(600, 300),
          labelY: const ['400', '600'],
          labelX: _labelX,
          showDescription: true,
          graphColor: Colors.black,
        ),
*/
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
            center: centerScreen,
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

  Future<void> changeLayer() async {
    LatLng currentPositon = await _getCurrentPosition();
    addMarker(currentPositon);
    centerScreen = currentPositon;
    setState(() {});
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

    try {
      // getData() returns a json Decoded data
      // data = await network.getData();
      OpenRouteService openRouteService = OpenRouteService(
          apiKey: '5b3ce3597851110001cf6248f83ccaf685cb453bb7c34e18c7a9e31f');
      List<ORSCoordinate> routeCoordinates =
          await openRouteService.directionsRouteCoordsGet(
              startCoordinate: ORSCoordinate(
                  latitude: _allPoints.elementAt(0).latitude,
                  longitude: _allPoints.elementAt(0).longitude),
              endCoordinate: ORSCoordinate(
                  latitude: _allPoints.elementAt(1).latitude,
                  longitude: _allPoints.elementAt(1).longitude));

      for (int i = 0; i < routeCoordinates.length; i++) {
        _allRoutePoints.add(LatLng(
            routeCoordinates[i].latitude, routeCoordinates[i].longitude));

        if (i % 15 == 0) {
          var pointElevation = await openRouteService.elevationPointGet(
              geometry: ORSCoordinate(
                  latitude: routeCoordinates[i].latitude,
                  longitude: routeCoordinates[i].longitude));
          _allElevation.add(pointElevation.coordinates[0].altitude);
        }
      }
      startElevation = await openRouteService.elevationPointGet(
          geometry: ORSCoordinate(
              latitude: _allPoints.elementAt(0).latitude,
              longitude: _allPoints.elementAt(0).longitude));
      endElevation = await openRouteService.elevationPointGet(
          geometry: ORSCoordinate(
              latitude: _allPoints.elementAt(1).latitude,
              longitude: _allPoints.elementAt(1).longitude));
      var data = await openRouteService.directionsRouteGeoJsonGet(
          startCoordinate: ORSCoordinate(
              latitude: _allPoints.elementAt(0).latitude,
              longitude: _allPoints.elementAt(0).longitude),
          endCoordinate: ORSCoordinate(
              latitude: _allPoints.elementAt(1).latitude,
              longitude: _allPoints.elementAt(1).longitude));
      duration = data.features[0].properties['segments'][0]['duration'];
      distance = data.features[0].properties['segments'][0]['distance'];

      setGraphValue();

      setPolyLines();
    } catch (e) {
      print(e);
    }
  }

  setGraphValue() {
    List<double> listdouble = [];
    for (int i = 0; i < _allElevation.length; i++) {
      listdouble.add(_allElevation[i]! / 1000);
      _labelX.add("");
    }
    _features.add(Feature(data: listdouble, color: Colors.green));
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
        routeName: nameOfRoute,
        startPoint: "Bramois",
        endPoint: "Liddes",
        coordinates: coordinates,
        distanceKm: distance as double,
        durationMinutes: duration / 60 as double,
        creatorId: UserDB().getConnectedFirebaseUser()!.uid,
        heightDiffUpMeters: 0,
        heightDiffDownMeters: 0,
        numberOfLikes: 0);
    bool success = await routeDB.addRoute(route);

    // navigate to all routes
    Navigator.pushNamed(context, RouteNames.allRoutes);
  }

  Future _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    bool serviceEnabled;

    serviceEnabled = await _geolocatorPlateform.isLocationServiceEnabled();
    if (serviceEnabled) {
      final position = await _geolocatorPlateform.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    }
  }
}
