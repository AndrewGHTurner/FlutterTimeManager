import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const Menu({super.key, BuildContext? context, required this.globalKey});
  @override
  Widget build(BuildContext context) {
    print("HERE");
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text("menu"),
        ),
        ListTile(
          title: Text("Home"),
          onTap: () => globalKey.currentState?.closeDrawer(),
        )
      ],
    );
  }
}
