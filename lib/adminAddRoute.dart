import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grp_6_bicycle/mapUtils.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(title: "Draw a route"),
        body: Center(child: MarkersOnMap()));
  }
}
