import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';
import 'package:grp_6_bicycle/DB/FirebaseConst.dart';

class UserDB {
  final userRef = FirebaseConst.userRef;

  Future<UserDTO?> getConnectedUser() async {
    User? firebaseUser = getConnectedFirebaseUser();
    if (firebaseUser == null) return null;
    return getUserById(firebaseUser.uid);
  }

  User? getConnectedFirebaseUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserDTO?> getUserById(String id) async {
    return await userRef.doc(id).get().then((snapshot) => snapshot.data()!);
  }

  void createUser(String userAuthId, UserDTO user) async {
    await userRef.doc(userAuthId).set(user);
  }
}
