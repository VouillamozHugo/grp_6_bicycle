import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/mapUtils.dart';
import 'package:grp_6_bicycle/smallmap.dart';

import 'details_route.dart';

const int itemCount = 20;

class AllRoutes extends StatelessWidget {
  const AllRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      itemBuilder: (BuildContext contect, int index) {
        return const Card(
          margin: EdgeInsets.all(10.0),
          child: Routes(),
        );
      },
      separatorBuilder: (context, position) {
        return const Card(
          color: Color.fromARGB(255, 252, 252, 252),
        );
      },
    );
  }
}

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const DetailsRoutes();
            },
          ),
        );
        ;
      },
      child: Container(
        decoration: myBoxDecoration(),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'From Bramois to Vex',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 80, 62, 33)),
                ),
                Icon(
                  Icons.warning,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.favorite,
                  color: Colors.pink,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Center(child: Text("Distance")),
                    Center(child: Text("Duration")),
                    Center(child: Text("+700m")),
                  ],
                ),
                Column(
                  children: const [
                    Center(child: Text("4km")),
                    Center(child: Text("60m")),
                    Center(child: Text("-200m")),
                  ],
                ),
                const smallMap()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: const Color.fromARGB(247, 247, 247, 247),
    border: Border.all(
      color: const Color.fromARGB(255, 80, 62, 33),
      width: 1.0,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}
