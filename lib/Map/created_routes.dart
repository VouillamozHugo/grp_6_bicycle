import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteWithIdDB.dart';
import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/Map/route_list.dart';
import 'package:grp_6_bicycle/display_logic/login_manager.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';

import '../DB/UserDB.dart';
import '../DTO/UserDTO.dart';

class CreatedRoutes extends StatefulWidget {
  const CreatedRoutes({super.key});

  @override
  State<CreatedRoutes> createState() => _CreatedRoutesState();
}

class _CreatedRoutesState extends State<CreatedRoutes> {
  //before the build to avoid reset at every render
  List<RouteWithId> routes = [];
  UserDTO? user;

  @override
  Widget build(BuildContext context) {
    redirectNonAdminUser();
    getCreatedRoutes();
    return RoutesList(
      fullRoutes: routes,
      listTitle: "Created routes",
      areRoutesEditable: true,
    );
  }

  getCreatedRoutes() async {
    // condition to only access the db once
    if (user != null) return;
    debugPrint("DATABASE ACCESS");

    // access user
    UserDB udb = UserDB();
    UserDTO? userTemp = await udb.getConnectedUser();
    if (userTemp == null) return;

    // access user's routes
    RouteWithIdDB routeDB = RouteWithIdDB();
    List<RouteWithId> routesList =
        await routeDB.getCreatedRoutesByUser(userTemp);
    setState(() {
      user = userTemp;
      routes = routesList;
    });
  }

  redirectNonAdminUser() async {
    debugPrint("checking if the user is an admin");
    if (!await LoginManager.isAnAdminConnected()) {
      Navigator.pushNamed(context, RouteNames.login);
    }
  }
}
