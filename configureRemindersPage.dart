import 'package:flutter/material.dart';
import 'package:time_manager/sharedAppBar.dart';

import 'databaseController.dart';
import 'menuDrawer.dart';

class ConfigureRemindersPage extends StatefulWidget {
  DatabaseController database;
  ConfigureRemindersPage({Key? key, required this.database}) : super(key: key);
  @override
  ConfigureRemindersPageState createState() => ConfigureRemindersPageState();
}

class ConfigureRemindersPageState extends State<ConfigureRemindersPage> {
  late DatabaseController database;
  @override
  void initState() {
    super.initState();
    database = widget.database;
  }

  //final GlobalKey<FormState> formKeyt = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    return Scaffold(
        key: scaffoldKey,
        appBar: SharedAppBar(
          title: "Configure Reminders",
        ),
        body: Form(child: Text("I")),
        drawer: MenuDrawer(
          database: database,
        ));
  }
}
