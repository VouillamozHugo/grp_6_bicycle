import 'package:flutter/material.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({super.key});

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Report a bug'),
          backgroundColor: const Color.fromARGB(255, 131, 90, 33),
          foregroundColor: const Color.fromARGB(255, 252, 252, 252),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const Text('BUG'));
  }
}
