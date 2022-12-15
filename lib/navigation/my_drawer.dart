import 'package:flutter/material.dart';

import '../Map/all_routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(60, 131, 90, 33),
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(60, 183, 118, 34),
              ),
              accountName: Text(
                "Alex Moos",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text("alex.moos@gmail.com"),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(60, 131, 90, 33),
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllRoutes()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text(' All routes '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllRoutes()),
              );
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
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/logo6.png',
                height: 60,
                width: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
