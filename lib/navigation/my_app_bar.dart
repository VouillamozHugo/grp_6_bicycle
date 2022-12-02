import 'package:flutter/material.dart';

import '../adminAddRoute.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  const MyAppBar({super.key}) : preferredSize = const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("CycleWay"),
      backgroundColor: const Color.fromARGB(255, 131, 90, 33),
      foregroundColor: const Color.fromARGB(255, 252, 252, 252),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const AdminMap();
                },
              ),
            );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
