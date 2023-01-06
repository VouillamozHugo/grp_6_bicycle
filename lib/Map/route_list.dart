import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/BLL/route_sorter.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/Map/details_route.dart';

import 'package:grp_6_bicycle/smallmap.dart';
import 'package:latlong2/latlong.dart';

import '../DB/RouteDB.dart';
import '../DTO/UserDTO.dart';
import '../navigation/my_app_bar.dart';
import '../navigation/my_drawer.dart';

class RoutesList extends StatefulWidget {
  final List<RouteWithId> fullRoutes;
  final String listTitle;
  final bool areRoutesEditable;

  const RoutesList({
    super.key,
    required this.fullRoutes,
    required this.listTitle,
    required this.areRoutesEditable,
  });

  @override
  State<RoutesList> createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  UserDTO? user;
  final sortingCriterias = [
    "distance",
    "duration",
    "Height difference",
  ];
  String selectedCriteria = "distance";
  bool isSortingAsc = true;

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: MyAppBar(
        title: widget.listTitle,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              DropdownButton(
                  items: sortingCriterias.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  value: selectedCriteria,
                  onChanged: (newValue) => setSelection(newValue)),
              IconButton(
                onPressed: sortRoutes,
                icon: isSortingAsc
                    ? const Icon(Icons.arrow_downward)
                    : const Icon(Icons.arrow_upward),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.fullRoutes.length,
              itemBuilder: (BuildContext contect, int index) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Routes(widget.fullRoutes[index],
                      widget.areRoutesEditable, user!),
                );
              },
              separatorBuilder: (context, position) {
                return const Card(
                  color: Color.fromARGB(255, 252, 252, 252),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  setSelection(String? newValue) {
    setState(() {
      selectedCriteria = newValue!;
    });
  }

  sortRoutes() {
    setState(() {
      isSortingAsc = !isSortingAsc;
      RouteSorter()
          .sortRoute(widget.fullRoutes, selectedCriteria, isSortingAsc);
    });
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
  final RouteWithId routeWithId;
  final bool isRouteEditable;
  final UserDTO user;
  const Routes(this.routeWithId, this.isRouteEditable, this.user, {super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  late bool isFavorite;

  @override
  Widget build(BuildContext context) {
    isFavorite = widget.user.favoriteRoutes!.contains(widget.routeWithId.id);
    final LatLng startPoint = LatLng(
        widget.routeWithId.route.coordinates['startLatitude']!,
        widget.routeWithId.route.coordinates['startLongitude']!);
    final LatLng endPoint = LatLng(
        widget.routeWithId.route.coordinates['endLatitude']!,
        widget.routeWithId.route.coordinates['endLongitude']!);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsRoutes(
                  widget.routeWithId.route, widget.isRouteEditable);
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
                  widget.routeWithId.route.routeName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 80, 62, 33)),
                ),
                const Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
                Row(
                  children: [
                    Text("${widget.routeWithId.route.numberOfLikes}"),
                    IconButton(
                      onPressed: () {
                        //isFavorite = !isFavorite;
                        UserDB u = UserDB();
                        RouteDB r = RouteDB();
                        u.udpateFavorite(widget.user, widget.routeWithId.id);
                        setState(() {
                          r.udpateNumberOfLike(
                              widget.routeWithId.route, !isFavorite);
                          getFavorite(isFavorite);
                        });
                      },
                      icon: getFavorite(isFavorite),
                    ),
                  ],
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
                    Center(
                        child:
                            Text("${widget.routeWithId.route.distanceKm}km")),
                    Center(
                        child: Text(
                            "${widget.routeWithId.route.durationMinutes} min")),
                    Text(
                      widget.routeWithId.route.startPoint,
                      textAlign: TextAlign.left,
                    ),
                    Center(child: Text(widget.routeWithId.route.endPoint)),
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
