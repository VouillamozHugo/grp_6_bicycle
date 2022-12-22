import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';

import 'DTO/RouteDTO.dart';

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key});

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  //before the build to avoid reset at every render
  List<RouteDTO> routes = [];

  @override
  Widget build(BuildContext context) {
    getAllRoutes();
    return RoutesList(
      routes: routes,
      listTitle: "All routes",
      areRoutesEditable: false,
    );
  }

  getAllRoutes() async {
    if (routes.isNotEmpty) return;
    debugPrint("DATABASE ACCESS");
    List<RouteDTO> routesList = await RouteDB().getAllRoutes();
    setState(() {
      routes = routesList;
    });
  }
}
