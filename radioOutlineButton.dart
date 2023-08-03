import 'package:flutter/material.dart';

class RadioOutlineButton extends StatefulWidget {
  List<String> options;

  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  RadioOutlineButton({Key? key, required this.options}) : super(key: key) {
    selectedIndex.value = 0;
  }
  @override
  State<RadioOutlineButton> createState() => _RadioOutlineButtonState();
}

class _RadioOutlineButtonState extends State<RadioOutlineButton> {
  Widget RadioOutlineButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          widget.selectedIndex.value = index;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: (widget.selectedIndex.value == index) ? Colors.blue : const Color.fromARGB(255, 128, 161, 177),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: (widget.selectedIndex.value == index) ? Colors.blue : const Color.fromARGB(255, 128, 161, 177))),
      ),
      child: Text(text,
          style: TextStyle(
            color: Colors.white,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = -1;
    List<Widget> buttons = [];
    widget.options.forEach((element) {
      index++;
      buttons.add(Expanded(child: RadioOutlineButton(element, index)));
    });
    return Row(
      // children: <Widget>[RadioOutlineButton("Single", 1), RadioOutlineButton("Married", 2), RadioOutlineButton("Other", 3)],
      children: buttons,
    );
  }
}
