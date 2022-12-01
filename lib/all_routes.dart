import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/mapUtils.dart';
import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';

import 'adminAddRoute.dart';
import 'details_route.dart';

const int itemCount = 20;

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  List<RouteDTO> routes = []; //before the build to avoid reset at every render

  @override
  Widget build(BuildContext context) {
    getAllRoutes();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My map"),
        backgroundColor: const Color.fromARGB(255, 131, 90, 33),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const AdminMap();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: routes.length,
        itemBuilder: (BuildContext contect, int index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Routes(routes[index]),
          );
        },
        separatorBuilder: (context, position) {
          return const Card(
            color: Color.fromARGB(255, 252, 252, 252),
          );
        },
      ),
    );
  }

  getAllRoutes() async {
    debugPrint("DATABASE ACCESS");
    RouteDB routeDB = RouteDB();
    List<RouteDTO> routesList = await routeDB.getAllRoutes();
    setState(() {
      routes = routesList;
    });
  }
}

class Routes extends StatefulWidget {
  final RouteDTO route;
  const Routes(this.route);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    final LatLng startPoint = LatLng(widget.route.coordinates['startLatitude']!,
        widget.route.coordinates['startLongitude']!);
    final LatLng endPoint = LatLng(widget.route.coordinates['endLatitude']!,
        widget.route.coordinates['endLongitude']!);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const DetailsRoutes();
            },
          ),
        );
      },
      child: Container(
        decoration: myBoxDecoration(),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.route.routeName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 80, 62, 33)),
                ),
                const Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.pink,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(child: Text("Distance")),
                    Center(child: Text("Duration")),
                    Center(child: Text("Start")),
                    Center(child: Text("End")),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(child: Text("${widget.route.distanceKm}km")),
                    Center(child: Text("${widget.route.heightDiffUpMeters}m")),
                    Text(
                      widget.route.startPoint,
                      textAlign: TextAlign.left,
                    ),
                    Center(child: Text(widget.route.endPoint)),
                  ],
                ),
                smallMap(startPoint, endPoint)
              ],
            ),
          ],
        ),
      ),
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
