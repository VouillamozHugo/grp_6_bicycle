import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grp_6_bicycle/DTO/UserDTO.dart';
import 'package:grp_6_bicycle/Map/mapUtils.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';

class AdminMap extends StatefulWidget {
  final UserDTO connectedUser;
  const AdminMap({super.key, required this.connectedUser});

  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  @override
  Widget build(BuildContext context) {
    //redirect non-admin users
    if (widget.connectedUser.userType != UserDTO.ADMIN_USER_TYPE) {
      Navigator.pushNamed(context, RouteNames.allRoutes);
    }
    return Scaffold(
        appBar: const MyAppBar(title: "Draw a route"),
        body: Center(
            child: MarkersOnMap(
          connectedUser: widget.connectedUser,
        )));
  }
}
