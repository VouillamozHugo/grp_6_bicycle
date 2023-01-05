import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grp_6_bicycle/DB/FirebaseConst.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

class RouteDB {
  final routeRef = FirebaseConst.routeRef;
  final userRef = FirebaseConst.userRef;

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
  Future<bool> udpateRoute(RouteDTO oldRoute, RouteDTO newRoute) async {
    // do not access db if no changes have been made
    if (oldRoute.routeName == newRoute.routeName &&
        oldRoute.startPoint == newRoute.startPoint &&
        oldRoute.endPoint == newRoute.endPoint) return false;

    // check user rights to update this route
    if (oldRoute.creatorId != UserDB().getConnectedFirebaseUser()!.uid) {
      return false;
    }

    //unique name constraint
    if (oldRoute.routeName != newRoute.routeName &&
        await getRouteByName(newRoute.routeName) != null) return false;

    try {
      final queryDocumentSnapshot =
          await getRouteDocumentSnapshotByName(oldRoute.routeName);
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
      //add in route collection
      DocumentReference<RouteDTO> createdRouteRef = await routeRef.add(route);

      //add in user created routes
      await userRef.doc(UserDB().getConnectedFirebaseUser()!.uid).update({
        "createdRoutes": FieldValue.arrayUnion([createdRouteRef.id]),
      });
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
    String routeId = queryDocumentSnapshot.id;
    String creatorId = queryDocumentSnapshot.data().creatorId;

    //delete from route collection
    await routeRef.doc(routeId).delete();

    //delete from users favorites
    deleteFromUserFavorite(routeId);

    //delete route reference from the admin that has created it
    deleteFromCreator(routeId, creatorId);

    return true;
  }

  void deleteFromUserFavorite(String routeId) async {
    final QuerySnapshot<UserDTO> route_fav_users =
        await userRef.where("favoriteRoutes", arrayContains: routeId).get();
    for (var doc in route_fav_users.docs) {
      userRef.doc(doc.id).update({
        "favoriteRoutes": FieldValue.arrayRemove([routeId])
      });
    }
  }

  void deleteFromCreator(String routeId, String creatorId) async {
    userRef.doc(creatorId).update({
      "createdRoutes": FieldValue.arrayRemove([routeId])
    });
  }
}
