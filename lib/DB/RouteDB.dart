import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grp_6_bicycle/DB/FirebaseConst.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';

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

  Future<bool> addRoute(RouteDTO route) async {
    //route name must be unique
    if (await getRouteByName(route.routeName) == null) {
      await routeRef.add(route);
      return true;
    }
    return false;
  }

  void deleteRouteByRouteName(String routeName) {
    final query = routeRef.where("routeName", isEqualTo: routeName);
  }
}
