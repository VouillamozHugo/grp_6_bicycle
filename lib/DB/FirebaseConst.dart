import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import '../DTO/UserDTO.dart';

class FirebaseConst {
  static final db = FirebaseFirestore.instance;

  static final userRef = db.collection('Users').withConverter(
        fromFirestore: UserDTO.fromFirestore,
        toFirestore: (UserDTO user, _) => user.ToFirestore(),
      );

  static final routeRef = db.collection('Routes').withConverter(
        fromFirestore: RouteDTO.fromFirestore,
        toFirestore: (RouteDTO route, _) => route.ToFirestore(),
      );
}
