import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';

import '../DB/RouteDB.dart';
import '../DB/UserDB.dart';
import '../DTO/RouteDTO.dart';
import '../DTO/UserDTO.dart';

class FavoriteRoutes extends StatefulWidget {
  const FavoriteRoutes({super.key});

  @override
  State<FavoriteRoutes> createState() => _FavoriteRoutesState();
}

class _FavoriteRoutesState extends State<FavoriteRoutes> {
  //before the build to avoid reset at every render
  List<RouteDTO> routes = [];
  UserDTO? user;

  @override
  Widget build(BuildContext context) {
    getFavoriteRoutes();
    return RoutesList(routes: routes, listTitle: "Favorite routes");
  }

  getFavoriteRoutes() async {
    if (user != null) return;
    debugPrint("DATABASE ACCESS");
    UserDB udb = UserDB();
    UserDTO userTemp = await udb.getUserById(udb.getConnectedUser()!.uid);
    RouteDB routeDB = RouteDB();
    List<RouteDTO> routesList =
        await routeDB.getFavoriteRoutesByUserId(userTemp);
    setState(() {
      user = userTemp;
      routes = routesList;
    });
  }
}
