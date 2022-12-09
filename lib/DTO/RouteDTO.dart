import 'package:cloud_firestore/cloud_firestore.dart';

class RouteDTO {
  RouteDTO(
      {required this.routeName,
      required this.startPoint,
      required this.endPoint,
      required this.coordinates,
      required this.distanceKm,
      required this.durationMinutes,
      required this.heightDiffUpMeters,
      required this.heightDiffDownMeters});

  final String routeName;
  final String startPoint;
  final String endPoint;
  final Map<String, double> coordinates;
  final double distanceKm;
  final double durationMinutes;
  final int heightDiffUpMeters;
  final int heightDiffDownMeters;

  factory RouteDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RouteDTO(
      routeName: data?['routeName'],
      startPoint: data?['startPoint'],
      endPoint: data?['endPoint'],
      coordinates: Map.from(data?['coordinates']),
      distanceKm: data?['distanceKm'],
      durationMinutes: data?['durationMinutes'],
      heightDiffUpMeters: data?['heightDiffUpMeters'],
      heightDiffDownMeters: data?['heightDiffDownMeters'],
    );
  }

  Map<String, Object?> ToFirestore() {
    return {
      'routeName': routeName,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'coordinates': coordinates,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'heightDiffUpMeters': heightDiffUpMeters,
      'heightDiffDownMeters': heightDiffDownMeters,
    };
  }
}
