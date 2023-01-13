import 'package:cloud_firestore/cloud_firestore.dart';

class UserDTO {
  UserDTO(
      {required this.firstName,
      required this.lastName,
      required this.userType,
      required this.favoriteRoutes,
      this.createdRoutes});
  final String firstName;
  final String lastName;
  final int userType;
  final List<String>? favoriteRoutes;
  final List<String>? createdRoutes;

  static const BIKER_USER_TYPE = 1;
  static const ADMIN_USER_TYPE = 2;

  factory UserDTO.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDTO(
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      userType: data?['userType'],
      favoriteRoutes: data?['favoriteRoutes'] is Iterable
          ? List.from(data?['favoriteRoutes'])
          : null,
      createdRoutes: data?['createdRoutes'] is Iterable
          ? List.from(data?['createdRoutes'])
          : null,
    );
  }

  Map<String, Object?> ToFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
      'favoriteRoutes': favoriteRoutes,
      'createdRoutes': createdRoutes,
    };
  }
}
