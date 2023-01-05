import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DB/RouteWithIdDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  List<RouteWithId> routes =
      []; //before the build to avoid reset at every render

  @override
  Widget build(BuildContext context) {
    debugPrint("ALL ROUTES WIDGET BUILD");
    getAllRoutes();
    return RoutesList(
      fullRoutes: routes,
      listTitle: "All routes",
      areRoutesEditable: false,
    );
  }

  getAllRoutes() async {
    if (routes.isNotEmpty) return;
    debugPrint("DATABASE ACCESS");
    RouteWithIdDB routeDB = RouteWithIdDB();
    List<RouteWithId> routesList = await routeDB.getAllRoutes();
    setState(() {
      routes = routesList;
    });
  }
}
