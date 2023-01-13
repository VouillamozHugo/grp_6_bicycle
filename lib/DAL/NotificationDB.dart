import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:grp_6_bicycle/DAL/FirebaseConst.dart';
import 'package:grp_6_bicycle/DAL/UserDB.dart';
import 'package:grp_6_bicycle/DTO/NotificationDTO.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

class NotificationDB {
  final notifRef = FirebaseConst.notifRef;

  Future<bool> addNotif(NotificationDTO notif) async {
    //route name must be unique

    await notifRef.add(notif);
    return true;
  }
}
