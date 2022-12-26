import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

import 'FirebaseConst.dart';

class RouteWithIdDB {
  final routeRef = FirebaseConst.routeRef;

  Future<List<RouteWithId>> getFavoritesRoutesByUser(UserDTO user) async {
    if (user.favoriteRoutes == null || user.favoriteRoutes!.isEmpty) {
      return [];
    }
    final querySnapshot =
        //__name__ property points to the document id
        await routeRef.where('__name__', whereIn: user.favoriteRoutes).get();
    List<RouteWithId> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(RouteWithId(id: doc.id, route: doc.data()));
    }
    return routes;
  }
}
