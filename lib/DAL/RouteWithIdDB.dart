import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grp_6_bicycle/DTO/RouteWithId.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

import '../DTO/RouteDTO.dart';
import 'FirebaseConst.dart';

class RouteWithIdDB {
  final routeRef = FirebaseConst.routeRef;

  List<RouteWithId> mapQuerySnapshotToRouteWithIdList(
      QuerySnapshot<RouteDTO> querySnapshot) {
    List<RouteWithId> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(RouteWithId(id: doc.id, route: doc.data()));
    }
    return routes;
  }

  Future<List<RouteWithId>> getFavoritesRoutesByUser(UserDTO user) async {
    if (user.favoriteRoutes == null || user.favoriteRoutes!.isEmpty) {
      return [];
    }
    final querySnapshot =
        //__name__ property points to the document id
        await routeRef.where('__name__', whereIn: user.favoriteRoutes).get();
    return mapQuerySnapshotToRouteWithIdList(querySnapshot);
  }

  Future<List<RouteWithId>> getRoutesByCreatorId(String creatorId) async {
    final querySnapshot =
        await routeRef.where("creatorId", isEqualTo: creatorId).get();
    return mapQuerySnapshotToRouteWithIdList(querySnapshot);
  }

  Future<List<RouteWithId>> getAllRoutes() async {
    final querySnapshot = await routeRef.get();
    return mapQuerySnapshotToRouteWithIdList(querySnapshot);
  }

  Future<List<RouteWithId>> getCreatedRoutesByUser(UserDTO user) async {
    if (user.createdRoutes == null || user.createdRoutes!.isEmpty) {
      return [];
    }
    final querySnapshot =
        //__name__ property points to the document id
        await routeRef.where('__name__', whereIn: user.createdRoutes).get();
    return mapQuerySnapshotToRouteWithIdList(querySnapshot);
  }
}
