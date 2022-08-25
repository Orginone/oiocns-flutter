import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../config/custom_colors.dart';

class TextSearch extends StatelessWidget {
  final TextSearchController textSearchController;

  const TextSearch(this.textSearchController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.searchGrey),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: const Icon(Icons.search)),
          Expanded(
            child: TextFormField(
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}

class TextSearchController extends GetxController {}
