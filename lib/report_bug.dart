import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/navigation/my_app_bar.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({super.key});

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(title: 'Report a problem'),
      body: Text('BUG'),
    );
  }
}
