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

  void printStuff() {
    print("K)");
    clickCount += 1;
    // build(context);
  }

  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: SharedAppBar(
          title: "Home Page",
          scaffoldKey: _globalKey,
        ),
        body: DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(255, 179, 255, 93)),
            child: Center(
                child: Column(children: [
              FutureBuilder(
                  future: databaseController.getDatabasePath(),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return (Text(snapshot.data.toString()));
                    } else {
                      return const Text("No Data");
                    }
                  }),
              FutureBuilder(
                  future: databaseController.checkDatabaseExists(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      return (Text("database exists"));
                    } else {
                      return const Text("database does not exist");
                    }
                  }),
              FutureBuilder(
                  future: databaseController.checkTableExists("tasks"),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return (Text(snapshot.data.toString()));
                    } else {
                      return const Text("no data");
                    }
                  }),
              Text("You clicked: " + clickCount.toString()),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      clickCount += 1;
                      print("HH");
                    });
                  },
                  child: const Text("my first button"))
            ]))),
        drawer: MenuDrawer(
          database: databaseController,
        ));
  }
}
