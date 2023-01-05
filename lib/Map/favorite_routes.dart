import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';

import '../DB/RouteWithIdDB.dart';
import '../DB/UserDB.dart';
import '../DTO/UserDTO.dart';

class FavoriteRoutes extends StatefulWidget {
  const FavoriteRoutes({super.key});

  @override
  State<FavoriteRoutes> createState() => _FavoriteRoutesState();
}

class _FavoriteRoutesState extends State<FavoriteRoutes> {
  //before the build to avoid reset at every render
  List<RouteWithId> routes = [];
  UserDTO? user;

  @override
  Widget build(BuildContext context) {
    getFavoriteRoutes();
    return RoutesList(
      fullRoutes: routes,
      listTitle: "Favorite routes",
      areRoutesEditable: false,
    );
  }

  getFavoriteRoutes() async {
    // condition to only access the db once
    if (user != null) return;
    debugPrint("DATABASE ACCESS");

    //access user
    UserDB udb = UserDB();
    UserDTO? userTemp = await udb.getConnectedUser();
    if (userTemp == null) return;

    // access user's routes
    RouteWithIdDB routeDB = RouteWithIdDB();
    List<RouteWithId> routesList =
        await routeDB.getFavoritesRoutesByUser(userTemp);
    setState(() {
      user = userTemp;
      routes = routesList;
    });
  }
}
