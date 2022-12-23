import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grp_6_bicycle/DB/FirebaseConst.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

class RouteDB {
  final routeRef = FirebaseConst.routeRef;

  /*
  Single member query
  */

  Future<RouteDTO> getRouteById(String id) async {
    return await routeRef.doc(id).get().then((snapshot) => snapshot.data()!);
  }

  Future<RouteDTO?> getRouteByName(String routeName) async {
    try {
      final queryDocumentSnapshot =
          await getRouteDocumentSnapshotByName(routeName);
      return queryDocumentSnapshot.data();
      //throws an exception when no route is found
    } on StateError {
      return null;
    }
  }

  // the queryDocumentSnapshot contains the document id and its data
  Future<QueryDocumentSnapshot<RouteDTO>> getRouteDocumentSnapshotByName(
      String routeName) async {
    final querySnapshot =
        await routeRef.where("routeName", isEqualTo: routeName).get();
    //throws an exception if the number of records is different than 1
    try {
      return querySnapshot.docs.single;
    } on StateError {
      throw StateError("Document with name ${routeName}not found.");
    }
  }

  /*
   Multiple member query 
   */

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

  /*
  Edit
  */
  Future<bool> udpateRoute(String routeToUpdateName, RouteDTO newRoute) async {
    try {
      final queryDocumentSnapshot =
          await getRouteDocumentSnapshotByName(routeToUpdateName);
      routeRef.doc(queryDocumentSnapshot.id).set(newRoute);
      return true;
      //throws an exception when no route is found
    } on StateError {
      return false;
    }
  }

  /*
  Add
   */
  Future<bool> addRoute(RouteDTO route) async {
    //route name must be unique
    if (await getRouteByName(route.routeName) == null) {
      await routeRef.add(route);
      return true;
    }
    return false;
  }

  /*
  Delete
  */
  Future<bool> deleteRouteByRouteName(String routeName) async {
    final queryDocumentSnapshot =
        await getRouteDocumentSnapshotByName(routeName);
    await routeRef.doc(queryDocumentSnapshot.id).delete();
    return true;
  }
}
