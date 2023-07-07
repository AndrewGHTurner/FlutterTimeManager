import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext) {
    return Center(
      child: Text("MENU"),
    );
  }
}
