import 'package:grp_6_bicycle/DTO/RouteWithId.dart';

class RouteSorter {
  void sortRoute(
      List<RouteWithId> routeList, String criteria, bool isSortingAsc) {
    switch (criteria) {
      case "distance":
        sortRouteByDistance(routeList, isSortingAsc);
        break;
      case "duration":
        sortRouteByDuration(routeList, isSortingAsc);
        break;
      case "Height difference":
        sortRouteByHeightDiff(routeList, isSortingAsc);
        break;
    }
  }

  void sortRouteByDistance(List<RouteWithId> routeList, bool isSortingAsc) {
    if (isSortingAsc) {
      routeList
          .sort((a, b) => a.route.distanceKm.compareTo(b.route.distanceKm));
    } else {
      routeList
          .sort((a, b) => b.route.distanceKm.compareTo(a.route.distanceKm));
    }
  }

  void sortRouteByDuration(List<RouteWithId> routeList, bool isSortingAsc) {
    if (isSortingAsc) {
      routeList.sort(
          (a, b) => a.route.durationMinutes.compareTo(b.route.durationMinutes));
    } else {
      routeList.sort(
          (a, b) => b.route.durationMinutes.compareTo(a.route.durationMinutes));
    }
  }

  void sortRouteByHeightDiff(List<RouteWithId> routeList, bool isSortingAsc) {
    if (isSortingAsc) {
      routeList.sort((a, b) =>
          a.route.heightDiffMeters.compareTo(b.route.heightDiffMeters));
    } else {
      routeList.sort((a, b) =>
          b.route.heightDiffMeters.compareTo(a.route.heightDiffMeters));
    }
  }
}
