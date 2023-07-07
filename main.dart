import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("state initialized");
  }

  void printStuff() {
    print("K)");
    clickCount += 1;
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    print("J");
    return Scaffold(
        appBar: AppBar(
          //this is the bar at the top of the application
          leading: const IconButton(
            icon: const Icon(Icons.menu),
            onPressed: null,
          ),
          title: const Text("Time manager"),
        ),
        body: Center(
            child: Column(children: [
          Text("Hello World"),
          Text("You clicked: " + clickCount.toString()),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  clickCount += 1;
                  print("HH");
                });
              },
              child: const Text("my first button"))
        ])));
  }
}
