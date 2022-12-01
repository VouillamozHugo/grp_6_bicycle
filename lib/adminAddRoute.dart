import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grp_6_bicycle/mapUtils.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My fucking map"),
          backgroundColor: const Color.fromARGB(255, 131, 90, 33),
          foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        ),
        body: const Center(child: MarkersOnMap()));
  }
}
