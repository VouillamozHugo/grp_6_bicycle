import 'package:cloud_firestore/cloud_firestore.dart';

class RouteDTO {
  RouteDTO(
      {required this.creatorId,
      required this.routeName,
      required this.startPoint,
      required this.endPoint,
      required this.coordinates,
      required this.distanceKm,
      required this.durationMinutes,
      required this.heightDiffMeters,
      required this.numberOfLikes});

  final String creatorId;
  String routeName;
  String startPoint;
  String endPoint;
  final Map<String, double> coordinates;
  final double distanceKm;
  final double durationMinutes;
  final int heightDiffMeters;
  int numberOfLikes;

  factory RouteDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RouteDTO(
        creatorId: data?['creatorId'],
        routeName: data?['routeName'],
        startPoint: data?['startPoint'],
        endPoint: data?['endPoint'],
        coordinates: Map.from(data?['coordinates']),
        distanceKm: data?['distanceKm'],
        durationMinutes: data?['durationMinutes'],
        heightDiffMeters: data?['heightDiffMeters'],
        numberOfLikes: data?['numberOfLikes']);
  }

  Map<String, Object?> ToFirestore() {
    return {
      'creatorId': creatorId,
      'routeName': routeName,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'coordinates': coordinates,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'heightDiffMeters': heightDiffMeters,
      'numberOfLikes': numberOfLikes,
    };
  }

  RouteDTO clone() {
    return RouteDTO(
        creatorId: creatorId,
        routeName: routeName,
        startPoint: startPoint,
        endPoint: endPoint,
        coordinates: coordinates,
        distanceKm: distanceKm,
        durationMinutes: durationMinutes,
        heightDiffMeters: heightDiffMeters,
        numberOfLikes: numberOfLikes);
  }
}
