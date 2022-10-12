import 'package:flutter/material.dart';
import 'package:orginone/config/custom_colors.dart';

class ChooseItemType1 extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function goto;

  const ChooseItemType1(this.icon, this.label, this.goto, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          goto();
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 10,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 15),
                        ))),
                const Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right))
              ],
            )));
  }
}