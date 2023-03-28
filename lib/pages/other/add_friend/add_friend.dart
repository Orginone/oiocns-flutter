// import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/components/template/base_list_view.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/routers.dart';

class AddFriendPage extends StatelessWidget {
  AddFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    var col = Column(children: () {
      var widgets = <Widget>[];
      const text = InputDecoration(
        labelText: '通过手机号/账号搜索',
        hintText: '请输入手机号/账号',
      );
      const pd = Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(decoration: text),
      );
      widgets.add(pd);
      if (text.labelText != null &&
          text.hintText != null &&
          text.prefixText != null) {
        AlertDialog(
          title: Text(text.toString()),
        );
      } else {
        // context
        widgets.addAll([
          SizedBox(height: 16.0),
          InkWell(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text("我的二维码:"),
                Icon(Icons.qr_code),
              ],
            ),
            onTap: () {
              _showDrawer(context);
            },
          ),
          SizedBox(height: 16.0),
          Divider(),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('面对面建群'),
            onTap: () {
              // TODO: Add scan QR code logic
              Get.toNamed(Routers.scanning);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.qr_code_scanner_sharp),
            title: Text('扫一扫'),
            onTap: () {
              // TODO: Add scan QR code logic
              Get.toNamed(Routers.scanning);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('手机联系人'),
            onTap: () {
              // TODO: Add phone contacts logic
            },
          ),
          Divider(),
        ]);
      }
      ;

      // list1.addAll(changePage(1));
      return widgets;
    }());

    return Scaffold(
      appBar: AppBar(
        title: Text('添加好友'),
        centerTitle: true,
      ),
      body: col,
    );
  }

  void _showDrawer(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: Column(children: [
              SizedBox(height: 16.0),
              Text.rich(TextSpan(text: '我的二维码')),
              SizedBox(height: 16.0),
              Container(
                height: 200,
                child: Image.network(
                    "https://qrcode.tec-it.com/API/QRCode?data=https://flutter.dev&errorcorrection=H"),
              )
            ]),
          );
        });
  }

  List<Widget> changePage(type) {
    const List<Widget> widgets = [];
    widgets.add(const Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: '通过手机号/账号搜索',
          hintText: '请输入手机号/账号',
        ),
      ),
    ));
    if (0 == type) {
      widgets.addAll([
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: '通过手机号/账号搜索',
              hintText: '请输入手机号/账号',
            ),
          ),
        ),
        SizedBox(height: 16.0),
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Text("我的二维码:"),
              Icon(Icons.qr_code),
            ],
          ),
          // onTap: () {
          //   _showDrawer(context);
          // },
        ),
        SizedBox(height: 16.0),
        Divider(),
        ListTile(
          leading: Icon(Icons.group_add),
          title: Text('面对面建群'),
          onTap: () {
            // TODO: Add scan QR code logic
            Get.toNamed(Routers.scanning);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.qr_code_scanner_sharp),
          title: Text('扫一扫'),
          onTap: () {
            // TODO: Add scan QR code logic
            Get.toNamed(Routers.scanning);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.contacts),
          title: Text('手机联系人'),
          onTap: () {
            // TODO: Add phone contacts logic
          },
        ),
        Divider(),
      ]);
    }
    return widgets;
  }
}

class AddFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddFriendController());
  }
}

class AddFriendController extends BaseListController<XRelation> {
  int limit = 20;
  int offset = 0;
  // CreatorController? _creatorController;
  TextEditingController? _textEditingController;
  @override
  void onInit() {
    super.onInit();
    // _creatorController = CreatorController();
    _textEditingController = TextEditingController();
    onRefresh();
  }

  @override
  void onLoadMore() async {
    // offset += 1;
    // var pageResp = await PersonApi.approvalAll("0", limit, offset);
    // addData(true, pageResp);
  }

  @override
  void onRefresh() async {
    // var pageResp = await PersonApi.approvalAll("0", limit, offset);
    // addData(true, pageResp);
  }

  String getName(String userId) {
    var chatCtrl = Get.find<ChatController>();
    return chatCtrl.getName(userId);
  }

  void joinSuccess(XRelation friends) async {
    // ALoading.showCircle();
    // await PersonApi.joinSuccess(friends.id)
    //     .then((value) {
    //   //成功，刷新列表
    //   Fluttertoast.showToast(msg: "已通过");
    //   offset = 0;
    //   onRefresh();
    // })
    //     .onError((error, stackTrace) {})
    //     .whenComplete(() => ALoading.dismiss());
  }

  void joinRefuse(String id) async {
    // ALoading.showCircle();
    // await PersonApi.joinRefuse(id)
    //     .then((value) {
    //   //成功，刷新列表
    //   offset = 0;
    //   onRefresh();
    // })
    //     .onError((error, stackTrace) {})
    //     .whenComplete(() => ALoading.dismiss());
  }

  String getStatus(int status) {
    if (status >= 0 && status <= 100) {
      return "待批";
    } else if (status >= 100 && status < 200) {
      return "已通过";
    }
    return "已拒绝";
  }
}
