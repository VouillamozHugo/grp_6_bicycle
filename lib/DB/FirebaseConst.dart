import 'package:cloud_firestore/cloud_firestore.dart';
import '../DTO/UserDTO.dart';

class FirebaseConst {
  static final db = FirebaseFirestore.instance;

  static final userRef = db.collection('Users').withConverter(
        fromFirestore: UserDTO.fromFirestore,
        toFirestore: (UserDTO user, _) => user.ToFirestore(),
      );
}
