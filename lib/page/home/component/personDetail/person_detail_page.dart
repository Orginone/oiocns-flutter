import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'person_detail_controller.dart';

class PersonDetailPage extends GetView<PersonDetailController> {
  const PersonDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonDetailController>(
      init: PersonDetailController(),
      builder: (item) => Scaffold(
        appBar: GFAppBar(
          leading: GFIconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
            type: GFButtonType.transparent,
          ),
          title: Text(item.personDetail != null ? item.personDetail!.name : '',
              style: const TextStyle(fontSize: 24)),
        ),
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        body: Container(
          color: const Color.fromRGBO(255, 255, 255, 1),
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: const Text("企业/组织", style: TextStyle(fontSize: 12,color: Color.fromRGBO(130,130,130, 1))),
                                ),
                                Text(
                                    item.personDetail != null
                                        ? item.personDetail!.name
                                        : '',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            IconButton(onPressed: (){},  icon: const Icon(Icons.keyboard_arrow_right))
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: const Text("企业/组织", style: TextStyle(fontSize: 12,color: Color.fromRGBO(130,130,130, 1))),
                                ),
                                Text(
                                    item.personDetail != null
                                        ? item.personDetail!.name
                                        : '',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            IconButton(onPressed: (){},  icon: const Icon(Icons.keyboard_arrow_right))
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: const Text("企业/组织", style: TextStyle(fontSize: 12,color: Color.fromRGBO(130,130,130, 1))),
                                ),
                                Text(
                                    item.personDetail != null
                                        ? item.personDetail!.name
                                        : '',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            IconButton(onPressed: (){},  icon: const Icon(Icons.keyboard_arrow_right))
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 0,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
