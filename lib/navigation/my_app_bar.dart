import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';

import '../Map/adminAddRoute.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  const MyAppBar({super.key, required this.title})
      : preferredSize = const Size.fromHeight(50.0);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  UserDTO? connectedUser;
  @override
  Widget build(BuildContext context) {
    setConnectedUser();
    return AppBar(
      title: Text(widget.title),
      backgroundColor: const Color.fromARGB(255, 183, 118, 34),
      foregroundColor: const Color.fromARGB(255, 252, 252, 252),
      actions: [
        connectedUser == null ||
                connectedUser!.userType != UserDTO.ADMIN_USER_TYPE
            ? const SizedBox(width: 0)
            : IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AdminMap(
                          connectedUser: connectedUser!,
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
      ],
    );
  }

  void setConnectedUser() async {
    UserDB udb = UserDB();
    User? authUser = udb.getConnectedFirebaseUser();
    //if the user has already been do not reload it
    if (connectedUser != null || authUser == null) {
      return;
    }
    String loggedInId = authUser.uid;
    UserDTO? tempUser = await udb.getUserById(loggedInId);
    setState(() {
      connectedUser = tempUser;
    });
  }
}
