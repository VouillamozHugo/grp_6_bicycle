import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';
import 'package:grp_6_bicycle/navigation/my_drawer.dart';
import 'package:grp_6_bicycle/report_bug.dart';

import 'all_routes.dart';

class DetailsRoutes extends StatelessWidget {
  const DetailsRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: MyAppBar(
          title: "Route details",
        ),
        body: DetailsBuilder());
  }
}

class DetailsBuilder extends StatelessWidget {
  const DetailsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "From Bramois To Vex",
          style: TextStyle(
            color: const Color.fromARGB(255, 131, 90, 33),
            height: 2,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text('La jolie map d\'hugo UWU'),
        const DetailsText(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ReportBug();
                },
              ),
            );
          },
          child: const Text(
            'Report a problem with the route',
            style: TextStyle(
              color: Color.fromARGB(255, 51, 102, 204),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsText extends StatelessWidget {
  const DetailsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: myBoxDecoration(),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(8),
      height: 100,
      child: (Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Start"),
              Text("End"),
              Text("Distance"),
              Text("Duration"),
              Text("Height diff."),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text("Bramois"),
              Text("Vex"),
              Text("4km"),
              Text("60m"),
              Text("700m -200m"),
            ],
          ),
        ],
      )),
    );
  }
}
