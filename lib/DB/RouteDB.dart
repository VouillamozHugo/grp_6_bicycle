import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grp_6_bicycle/DB/FirebaseConst.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

class RouteDB {
  final routeRef = FirebaseConst.routeRef;

  Future<RouteDTO> getRouteById(String id) async {
    return await routeRef.doc(id).get().then((snapshot) => snapshot.data()!);
  }

  Future<RouteDTO?> getRouteByName(String routeName) async {
    final querySnapshot =
        await routeRef.where("routeName", isEqualTo: routeName).get();
    try {
      //throws an exception if the number of records is different than 1
      return querySnapshot.docs.single.data();
    } on StateError {
      return null;
    }
  }

  Future<List<RouteDTO>> getRoutesByCreatorId(String creatorId) async {
    final querySnapshot =
        await routeRef.where("creatorId", isEqualTo: creatorId).get();
    List<RouteDTO> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(doc.data());
    }
    return routes;
  }

  Future<List<RouteDTO>> getFavoriteRoutesByUser(UserDTO user) async {
    if (user.favoriteRoutes == null || user.favoriteRoutes!.isEmpty) {
      return [];
    }
    final querySnapshot =
        //__name__ property points to the document id
        await routeRef.where('__name__', whereIn: user.favoriteRoutes).get();
    List<RouteDTO> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(doc.data());
    }
    return routes;
  }

  Future<List<RouteDTO>> getAllRoutes() async {
    final querySnapshot = await routeRef.get();
    List<RouteDTO> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(doc.data());
    }
    return routes;
  }

  Future<List<RouteDTO>> getCreatedRoutesByUser(UserDTO user) async {
    if (user.createdRoutes == null || user.createdRoutes!.isEmpty) {
      return [];
    }
    final querySnapshot =
        //__name__ property points to the document id
        await routeRef.where('__name__', whereIn: user.createdRoutes).get();
    List<RouteDTO> routes = [];
    for (var doc in querySnapshot.docs) {
      routes.add(doc.data());
    }
    return routes;
  }

  Future<bool> addRoute(RouteDTO route) async {
    //route name must be unique
    if (await getRouteByName(route.routeName) == null) {
      await routeRef.add(route);
      return true;
    }
    return false;
  }

  Future<bool> deleteRouteByRouteName(String routeName) async {
    final querySnapshot =
        await routeRef.where("routeName", isEqualTo: routeName).get();
    try {
      //throws an exception if the number of records is different than 1
      await routeRef.doc(querySnapshot.docs.single.id).delete();
      return true;
    } on StateError {
      return false;
    }
  }
}
