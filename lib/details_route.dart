import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/report_bug.dart';

import 'all_routes.dart';

class DetailsRoutes extends StatelessWidget {
  const DetailsRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Route Details'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const DetailsBuilder());
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
            children: const [
              Center(child: Text("Start")),
              Center(child: Text("End")),
              Center(child: Text("Distance")),
              Center(child: Text("Duration")),
              Center(child: Text("Height diff.")),
            ],
          ),
          Column(
            children: const [
              Center(child: Text("Bramois")),
              Center(child: Text("Vex")),
              Center(child: Text("4km")),
              Center(child: Text("60m")),
              Center(child: Text("700m -200m")),
            ],
          ),
        ],
      )),
    );
  }
}
