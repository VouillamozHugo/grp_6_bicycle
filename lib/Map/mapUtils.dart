import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/Map/all_routes.dart';
import 'package:grp_6_bicycle/Map/geolocation.dart';
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

  final GeolocatorPlatform _geolocatorPlateform = GeolocatorPlatform.instance;

  var layer =
      'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg';
  var sateliteIsOn = false;

  var data;
  var distance;
  var duration;
  var startElevation;
  var endElevation;

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
        LineGraph(
          features: _features,
          size: const Size(600, 300),
          labelY: const ['400', '600'],
          labelX: _labelX,
          showDescription: true,
          graphColor: Colors.black,
        ),
        FloatingActionButton(
          onPressed: changeLayer,
          child: const Icon(Icons.layers),
          backgroundColor: Colors.transparent,
        ),
        FloatingActionButton(
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

  Future<void> changeLayer() async {
    LatLng currentPositon = await _getCurrentPosition();
    addMarker(currentPositon);
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

      _allElevation.forEach(print);

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
        distanceKm: distance,
        durationMinutes: duration,
        heightDiffUpMeters: startElevation,
        heightDiffDownMeters: endElevation);
    bool success = await routeDB.addRoute(route);
    debugPrint("Start point " + success.toString());
    //clear previous navigation history
    //and load all routes page
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AllRoutes()),
        ModalRoute.withName("/Home"));
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
