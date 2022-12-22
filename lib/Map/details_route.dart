import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';
import 'package:grp_6_bicycle/navigation/my_drawer.dart';
import 'package:latlong2/latlong.dart';
import 'package:grp_6_bicycle/report_bug.dart';
import 'package:grp_6_bicycle/smallmap.dart';

class DetailsRoutes extends StatelessWidget {
  final RouteDTO route;
  final bool isRouteEditable;
  const DetailsRoutes(this.route, this.isRouteEditable, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: "Route details",
        ),
        body: DetailsBuilder(route));
  }
}

class DetailsBuilder extends StatelessWidget {
  final RouteDTO route;
  const DetailsBuilder(this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng startPoint = LatLng(route.coordinates['startLatitude']!,
        route.coordinates['startLongitude']!);
    final LatLng endPoint = LatLng(
        route.coordinates['endLatitude']!, route.coordinates['endLongitude']!);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          route.routeName,
          style: const TextStyle(
            color: Color.fromARGB(255, 131, 90, 33),
            height: 2,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SmallMap(startPoint, endPoint, 300, 800),
        DetailsText(route),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ReportBug();
                },
              ),
            );
          },
          child: const Text(
            'Report a problem with the route',
            style: TextStyle(
              color: Color.fromARGB(255, 51, 102, 204),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsText extends StatelessWidget {
  final RouteDTO route;
  const DetailsText(this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: myBoxDecoration(),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      height: 100,
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Start"),
              Text("End"),
              Text("Distance"),
              Text("Duration"),
              Text("Height diff."),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(route.startPoint),
              Text(route.endPoint),
              Text("${route.distanceKm}km"),
              Text("${route.durationMinutes}m"),
              Text(
                  "${route.heightDiffUpMeters}m -${route.heightDiffDownMeters}m"),
            ],
          ),
        ],
      )),
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(247, 247, 247, 247),
    border: Border.all(
      color: const Color.fromARGB(255, 80, 62, 33),
      width: 1.0,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}
