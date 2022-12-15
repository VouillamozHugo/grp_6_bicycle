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

  Future<List<RouteDTO?>> getRoutesByCreatorId(String creatorId) async {
    final querySnapshot =
        await routeRef.where("creatorId", isEqualTo: creatorId).get();
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
