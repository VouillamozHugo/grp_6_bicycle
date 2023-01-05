import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDTO {
  NotificationDTO({
    required this.problemDescription,
    required this.isValidatedByAdmin,
    required this.affectedRouteId,
    required this.problemType,
    required this.problemCoords,
  });

  final String problemDescription;
  final bool isValidatedByAdmin;
  final int affectedRouteId;
  final String problemType;
  final Map<String, double> problemCoords;

  factory NotificationDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return NotificationDTO(
        problemDescription: data?['problemDescription'],
        isValidatedByAdmin: data?['isValidatedByAdmin'],
        affectedRouteId: data?['affectedRouteId'],
        problemType: data?['problemType'],
        problemCoords: data?['problemCoords']);
  }

  Map<String, Object?> ToFirestore() {
    return {
      'problemDescription': problemDescription,
      'isValidatedByAdmin': isValidatedByAdmin,
      'affectedRouteId': affectedRouteId,
      'problemType': problemType,
      'problemCoords': problemCoords,
    };
  }
}
