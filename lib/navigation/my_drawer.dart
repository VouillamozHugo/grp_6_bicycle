import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/UserDB.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';
import 'package:grp_6_bicycle/login/LoginWrapper.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';

import '../Map/all_routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserDTO? loggedInUser;
  String? loggedInEmail;

  @override
  Widget build(BuildContext context) {
    setConnectedUser();
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(60, 131, 90, 33),
            ),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(60, 183, 118, 34),
              ),
              accountName: Text(
                loggedInUser != null ? loggedInUser!.firstName : "",
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text((loggedInEmail ?? "")),
              currentAccountPictureSize: const Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(60, 131, 90, 33),
                child: Text(
                  loggedInUser != null
                      ? loggedInUser!.firstName.substring(0, 1)
                      : "",
                  style: const TextStyle(fontSize: 30.0, color: Colors.white),
                ), //Text
              ), //circleAvatar
            ), //UserAccountDrawerHeader*/
            //BoxDecoration
            //child:
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(' My routes '),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.favoriteRoutes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text(' All routes '),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.allRoutes);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(' Settings '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Log out '),
            onTap: () {
              logout();
            },
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/logo6.png',
              height: 60,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void redirectUserToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginWrapper()));
  }

  void setConnectedUser() async {
    User? authUser = FirebaseAuth.instance.currentUser;
    //if the user has already been do not reload it
    if (loggedInUser != null || authUser == null) {
      return;
    }
    String loggedInId = authUser.uid;
    UserDTO? tempUser = await UserDB().getUserById(loggedInId);
    setState(() {
      loggedInUser = tempUser;
      loggedInEmail = authUser.email;
    });
  }
}
