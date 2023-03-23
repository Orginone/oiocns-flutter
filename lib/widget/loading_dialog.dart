import 'dart:async';
import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  static bool _requestShow = false;

  static ValueNotifier<String?> _messageNotifier = ValueNotifier<String?>(null);

  // String msg;
  final bool cancelable;
  static Timer? timer;

  LoadingDialog._({
    String? msg,
    this.cancelable = false,
  }) {
    _messageNotifier.value = msg ?? "";
  }

  static updateMessage(String msg) {
    _messageNotifier.value = msg;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      new CircularProgressIndicator(),
    ];
    children.add(
      ValueListenableBuilder<String?>(
        valueListenable: _messageNotifier,
        builder: (context, value, child) {
          return value!=null && value != ""
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 12,
                    right: 12,
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0),
                  ),
                )
              : SizedBox();
        },
      ),
    );
    return Material(
      type: MaterialType.transparency,
      child: WillPopScope(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                color: Color(0x44000000),
              ),
              onTap: () {
                if (cancelable) {
                  _dismiss(context);
                }
              },
            ),
            Center(
              child: SizedBox(
                width: 120.0,
                height: 120.0,
                child: Container(
                  decoration: const ShapeDecoration(
                    color: Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
        onWillPop: () async {
          if (cancelable) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        },
      ),
    );
  }

  void _dismiss(BuildContext context) {
    timer?.cancel();
    _requestShow = false;
    Navigator.of(context).pop();
  }

  static Future? showLoading(BuildContext context,
      {String? msg, bool cancelable = false, int dismissSeconds = 30}) {
    return show(context,msg: msg, cancelable: cancelable, dismissSeconds: dismissSeconds);
  }

  static Future? showWaiting(BuildContext context,
      {bool cancelable = false, int dismissSeconds = 30}) {
    return show(context,
        msg: "请稍等...",
        cancelable: cancelable,
        dismissSeconds: dismissSeconds);
  }

  static void createDismissTimer(BuildContext context,int dismissSeconds) {
    if (dismissSeconds > 0) {
      timer = Timer(Duration(seconds: dismissSeconds), () {
        dismiss(context);
      });
    }
  }

  static Future? show(BuildContext context,
      {String? msg, bool cancelable = false, required int dismissSeconds}) {
    if (_requestShow) {
      return null;
    }
    _requestShow = true;
    _showDialogInner(context,msg, cancelable);
    createDismissTimer(context,dismissSeconds);
  }

  static Future _showDialogInner(BuildContext context,String? msg, bool cancelable) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return LoadingDialog._(
            msg: msg,
            cancelable: cancelable,
          );
        },
      ),
    );
  }

  static Future<void> dismiss(BuildContext context) async {
    timer?.cancel();
    if (_requestShow) {
      _requestShow = false;
      return Navigator.of(context).pop();
    }
  }
}
