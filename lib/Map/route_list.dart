import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/Map/details_route.dart';

import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';

import '../DTO/UserDTO.dart';
import '../navigation/my_app_bar.dart';
import '../navigation/my_drawer.dart';

class RoutesList extends StatefulWidget {
  final List<RouteDTO> routes;
  final String listTitle;
  final bool areRoutesEditable;

  const RoutesList({
    super.key,
    required this.routes,
    required this.listTitle,
    required this.areRoutesEditable,
  });

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  UserDTO? user;
  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: MyAppBar(title: widget.listTitle),
      body: ListView.separated(
        itemCount: widget.routes.length,
        itemBuilder: (BuildContext contect, int index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Routes(widget.routes[index], widget.areRoutesEditable),
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

  getUser() async {
    if (user != null) return;
    UserDB u = UserDB();
    UserDTO? userTemp = await u.getConnectedUser();
    setState(() {
      user = userTemp;
    });
    debugPrint("User connected: ${user!.firstName}");
  }
}

class Routes extends StatefulWidget {
  final RouteDTO route;
  final bool isRouteEditable;
  const Routes(this.route, this.isRouteEditable, {super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  bool isFavorite = false;
  Icon favorite = const Icon(
    Icons.favorite,
  );

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
              return DetailsRoutes(widget.route, widget.isRouteEditable);
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
                IconButton(
                  onPressed: () {
                    isFavorite = !isFavorite;
                    setState(() {
                      getFavorite(isFavorite);
                    });
                  },
                  icon: getFavorite(isFavorite),
                ),
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
                SmallMap(startPoint, endPoint, 170, 200)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Icon getFavorite(bool isFav) {
  if (isFav) {
    return const Icon(
      Icons.favorite,
      color: Colors.pink,
    );
  } else {
    return const Icon(
      Icons.favorite_border,
      color: Colors.pink,
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(247, 247, 247, 247),
    border: myBorder(),
    borderRadius: const BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}

Border myBorder() {
  return Border.all(
    color: const Color.fromARGB(255, 80, 62, 33),
    width: 1.0,
  );
}