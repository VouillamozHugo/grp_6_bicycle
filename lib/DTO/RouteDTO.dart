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
      required this.heightDiffUpMeters,
      required this.heightDiffDownMeters,
      required this.numberOfLikes});

  final String creatorId;
  final String routeName;
  final String startPoint;
  final String endPoint;
  final Map<String, double> coordinates;
  final double distanceKm;
  final double durationMinutes;
  final int heightDiffUpMeters;
  final int heightDiffDownMeters;
  final int numberOfLikes;

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
        heightDiffUpMeters: data?['heightDiffUpMeters'],
        heightDiffDownMeters: data?['heightDiffDownMeters'],
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
      'heightDiffUpMeters': heightDiffUpMeters,
      'heightDiffDownMeters': heightDiffDownMeters,
      'numberOfLikes': numberOfLikes,
    };
  }
}
