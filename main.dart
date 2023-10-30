import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //for notifications
import "sharedAppBar.dart";
import "menuDrawer.dart";
import "databaseController.dart";

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Demo Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "Home page"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title = "l"}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int clickCount = 0;
  late String db = "j";
  DatabaseController databaseController = DatabaseController();

  @override
  void initState() {
    databaseController.makeDatabase();
    // TODO: implement initState
    super.initState();
    print("state initialized");
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double headingFontSize = screenwidth / 20;
    return Scaffold(
        key: _globalKey,
        appBar: SharedAppBar(
          title: "Home Page",
        ),
        body: DecoratedBox(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 179, 255, 93)),
            child: Center(child: Column(children: [Align(alignment: Alignment.centerLeft, child: Text("Next tasks Due:", style: TextStyle(fontSize: headingFontSize), textAlign: TextAlign.end))]))),
        drawer: MenuDrawer(
          database: databaseController,
        ));
  }
}
