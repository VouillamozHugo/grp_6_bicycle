import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/DB/RouteDB.dart';
import 'package:grp_6_bicycle/DTO/RouteDTO.dart';
import 'package:grp_6_bicycle/application_constants.dart';
import 'package:grp_6_bicycle/generic_widgets/form_button.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';
import 'package:grp_6_bicycle/navigation/my_drawer.dart';
import 'package:grp_6_bicycle/navigation/route_names.dart';
import 'package:latlong2/latlong.dart';
import 'package:grp_6_bicycle/report_bug.dart';
import 'package:grp_6_bicycle/smallmap.dart';

import '../login/register_page.dart';

class DetailsRoutes extends StatelessWidget {
  final RouteDTO route;
  final bool isRouteEditable;
  const DetailsRoutes(this.route, this.isRouteEditable, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: "Route details",
        ),
        body: DetailsBuilder(route, isRouteEditable));
  }
}

class DetailsBuilder extends StatefulWidget {
  final RouteDTO route;
  final bool isRouteEditable;
  const DetailsBuilder(this.route, this.isRouteEditable, {super.key});

  @override
  State<DetailsBuilder> createState() => _DetailsBuilderState();
}

class _DetailsBuilderState extends State<DetailsBuilder> {
  late RouteDTO route; //late as parent attribute can't be used as initializer
  int buildCount = 0;
  @override
  Widget build(BuildContext context) {
    //only use the parent (initial) route in the first render
    if (buildCount < 1) route = widget.route;
    buildCount++;

    //coords
    final LatLng startPoint = LatLng(route.coordinates['startLatitude']!,
        route.coordinates['startLongitude']!);
    final LatLng endPoint = LatLng(
        route.coordinates['endLatitude']!, route.coordinates['endLongitude']!);

    // input field controllers
    TextEditingController routeNameTextController =
        TextEditingController(text: route.routeName);
    TextEditingController startPointTextController =
        TextEditingController(text: route.startPoint);
    TextEditingController endPointTextController =
        TextEditingController(text: route.endPoint);

    // route name can't use the same method as other detail fields
    // as it has a different size and a different layout context
    final routeNameField = setRouteNameField(routeNameTextController);

    // conditional rendering: only admin can update and delete
    final updateRouteButton = setUpdateButton(
        formButtonStyle,
        routeNameTextController,
        startPointTextController,
        endPointTextController);
    final deleteRouteButton = setDeleteButton(formButtonStyle, route.routeName);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            updateRouteButton,
            const SizedBox(width: 10),
            deleteRouteButton,
            const SizedBox(width: 20),
          ],
        ),
        routeNameField,
        SmallMap(startPoint, endPoint, 300, 800),
        DetailsText(route, widget.isRouteEditable, startPointTextController,
            endPointTextController),
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

  Widget setDeleteButton(ButtonStyle buttonStyle, String routeName) {
    return widget.isRouteEditable
        ? OutlinedButton(
            onPressed: () => deleteRoute(routeName),
            style: buttonStyle,
            child: textCreator('Delete', ApplicationConstants.ORANGE))
        : const Center();
  }

  Widget setUpdateButton(
    ButtonStyle buttonStyle,
    TextEditingController routeNameTextController,
    TextEditingController startPointTextController,
    TextEditingController endPointTextController,
  ) {
    return widget.isRouteEditable
        ? OutlinedButton(
            onPressed: () => updateRoute(routeNameTextController,
                startPointTextController, endPointTextController),
            style: buttonStyle,
            child: textCreator('Edit', ApplicationConstants.ORANGE))
        : const Center();
  }

  void deleteRoute(String routeName) async {
    bool success = await RouteDB().deleteRouteByRouteName(routeName);
    if (success) {
      Navigator.pushNamed(context, RouteNames.createdRoutes);
    }
  }

  void updateRoute(
    TextEditingController routeNameTextController,
    TextEditingController startPointTextController,
    TextEditingController endPointTextController,
  ) async {
    // update the route in db
    RouteDTO newRoute = buildNewRoute(route, routeNameTextController.text,
        startPointTextController.text, endPointTextController.text);
    bool success = await RouteDB().udpateRoute(route, newRoute);

    //update the route in state
    if (success) {
      setState(() {
        route = newRoute;
      });
      return;
    }

    // reset fields in case of failure
    routeNameTextController.text = widget.route.routeName;
    startPointTextController.text = widget.route.startPoint;
    endPointTextController.text = widget.route.endPoint;
  }

  RouteDTO buildNewRoute(RouteDTO oldRoute, String newName,
      String newStartPoint, String newEndPoint) {
    RouteDTO newRoute = route.clone();
    newRoute.routeName = newName;
    newRoute.startPoint = newStartPoint;
    newRoute.endPoint = newEndPoint;
    return newRoute;
  }

  Widget setRouteNameField(TextEditingController routeNameTextController) {
    const routeNameTextStyle = TextStyle(
      color: Color.fromARGB(255, 131, 90, 33),
      height: 2,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
    return widget.isRouteEditable
        ? TextField(
            style: routeNameTextStyle,
            controller: routeNameTextController,
            textAlign: TextAlign.center,
          )
        : Text(
            route.routeName,
            style: routeNameTextStyle,
          );
  }
}

class DetailsText extends StatelessWidget {
  final RouteDTO route;
  final bool isRouteEditable;
  final TextEditingController startPointTextController;
  final TextEditingController endPointTextController;
  const DetailsText(this.route, this.isRouteEditable,
      this.startPointTextController, this.endPointTextController,
      {super.key});

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getTextFieldOrText(
                    isRouteEditable,
                    route.startPoint,
                    startPointTextController,
                    const TextStyle(),
                    TextAlign.right),
                getTextFieldOrText(isRouteEditable, route.endPoint,
                    endPointTextController, const TextStyle(), TextAlign.right),
                Text("${route.distanceKm}km"),
                Text("${route.durationMinutes}m"),
                Text(
                    "${route.heightDiffUpMeters}m -${route.heightDiffDownMeters}m"),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

Widget getTextFieldOrText(
    bool isRouteEditable,
    String initialText,
    TextEditingController textEditingController,
    TextStyle textStyle,
    TextAlign textAlign) {
  if (isRouteEditable) {
    return Expanded(
      child: TextField(
        style: textStyle,
        controller: textEditingController,
        textAlign: textAlign,
      ),
    );
  }
  return Text(
    initialText,
    style: textStyle,
  );
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
